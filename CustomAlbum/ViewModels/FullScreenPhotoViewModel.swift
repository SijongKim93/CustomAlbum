//
//  FullScreenPhotoViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI
import Photos


class FullScreenPhotoViewModel: ObservableObject {
    @Published var currentPhotoIndex: Int // 현재 표시되고 있는 사진의 인덱스입니다.
    @Published var selectedPhotoID: String? // 선택된 사진의 ID입니다.
    @Published var showFavoriteAnimation = false // 즐겨찾기 추가 시 애니메이션을 표시하는 플래그입니다.
    @Published var showInfoView = false // 사진 정보(위치, 날짜 등)를 표시하는 플래그입니다.
    @Published var shouldDismiss = false // 현재 사진이 삭제될 때 View를 닫기 위한 플래그입니다.
    
    var photos: [Photo]
    var onPhotoDeleted: ((String) -> Void)?

    
    init(photos: [Photo], initialIndex: Int) {
        self.photos = photos
        self.currentPhotoIndex = (0..<photos.count).contains(initialIndex) ? initialIndex : 0
        self.selectedPhotoID = photos[self.currentPhotoIndex].id
        loadFavoriteStates() // 초기화 시, 모든 사진의 즐겨찾기 상태를 불러옵니다.
    }
    
    // 현재 표시되고 있는 사진을 반환합니다.
    var currentPhoto: Photo {
        photos[currentPhotoIndex]
    }
    
    // 현재 선택된 사진 ID를 기반으로 인덱스를 업데이트합니다.
    func updateCurrentPhoto(id: String) {
        if let index = photos.firstIndex(where: { $0.id == id }) {
            currentPhotoIndex = index
            selectedPhotoID = id
        }
    }
    
    // MARK: - 공유 기능
    
    // UIActivityViewController를 사용해 공유 기능을 제공합니다.
    func toggleSharePhoto() {
        let image = currentPhoto.image
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let topController = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController {
            topController.present(activityController, animated: true, completion: nil)
        }
    }
    
    // MARK: - 즐겨 찾기
    

    func toggleFavorite() {
        withAnimation {
            photos[currentPhotoIndex].isFavorite.toggle()
            
            if photos[currentPhotoIndex].isFavorite {
                // 사진이 즐겨찾기에 추가된 경우, CoreData에 저장합니다.
                CoreDataManager.shared.saveFavoritePhoto(
                    id: photos[currentPhotoIndex].id,
                    image: photos[currentPhotoIndex].image,
                    date: photos[currentPhotoIndex].date,
                    location: photos[currentPhotoIndex].location,
                    assetIdentifier: photos[currentPhotoIndex].asset?.localIdentifier ?? ""
                )
                showFavoriteAnimation = true // 즐겨찾기 추가 애니메이션을 표시합니다.
            } else {
                // 즐겨찾기에서 제거된 경우, CoreData에서 삭제합니다.
                CoreDataManager.shared.deleteFavoritePhoto(by: photos[currentPhotoIndex].id)
                showFavoriteAnimation = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.showFavoriteAnimation = false
        }
    }
    
    // 앱이 시작될 때, 모든 사진의 즐겨찾기 상태를 불러오는 메서드입니다.
    private func loadFavoriteStates() {
        let favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos()
        
        // 현재 로드된 모든 사진의 즐겨찾기 상태를 업데이트합니다.
        for i in 0..<photos.count {
            if favoritePhotos.contains(where: { $0.id == photos[i].id }) {
                photos[i].isFavorite = true
            } else {
                photos[i].isFavorite = false
            }
        }
    }
    
    // MARK: - 인포 기능
    
    // 사진 정보 표시 여부를 토글하는 메서드입니다.
    func toggleInfo() {
        withAnimation {
            showInfoView.toggle()
        }
    }
    
    // 주어진 ID를 사용해 PHAsset을 가져오는 메서드입니다.
    private func fetchAsset(using identifier: String) -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: fetchOptions)
        return fetchResult.firstObject
    }
    
    // MARK: - 삭제 기능
    
    // 현재 사진을 삭제하는 메서드입니다. CoreData와 PHAsset에서 삭제를 처리합니다.
    func toggleDeletePhoto() {
        var assetToDelete = currentPhoto.asset
        if assetToDelete == nil, let identifier = currentPhoto.assetIdentifier {
            assetToDelete = fetchAsset(using: identifier)
        }
        
        if let asset = assetToDelete {
            deleteAsset(asset) // 사진이 있으면 삭제를 진행합니다.
        } else {
            // 사진이 없으면 Core Data에서 삭제합니다.
            CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
            self.photos.remove(at: currentPhotoIndex)
            self.shouldDismiss = true
        }
    }
    
    // PHAsset을 실제로 삭제하는 메서드입니다.
    private func deleteAsset(_ asset: PHAsset) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }, completionHandler: { success, error in
            if success {
                // 삭제가 성공하면 Core Data에서도 해당 사진을 삭제 후 화면을 이동합니다.
                DispatchQueue.main.async {
                    CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
                    self.shouldDismiss = true
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    CoreDataManager.shared.alertMessage = "사진 삭제 중 오류 발생: \(error.localizedDescription)"
                    CoreDataManager.shared.showAlert = true
                }
            }
        })
    }
    
    // 주어진 ID를 사용해 PHAsset을 가져와 삭제하는 메서드입니다.
    private func fetchAssetAndDelete(_ identifier: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: fetchOptions)
        if let asset = fetchResult.firstObject {
            deleteAsset(asset)
        } else {
            // 사진이 없으면 Core Data에서 삭제하고 화면을 닫습니다.
            CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
            self.shouldDismiss = true
        }
    }
}
