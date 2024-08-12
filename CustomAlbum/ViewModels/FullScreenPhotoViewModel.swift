//
//  FullScreenPhotoViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI
import Photos

class FullScreenPhotoViewModel: ObservableObject {
    @Published var currentPhotoIndex: Int
    @Published var selectedPhotoID: String?
    @Published var showFavoriteAnimation = false
    @Published var showInfoView = false
    @Published var shouldDismiss = false
    
    var photos: [Photo]
    var onPhotoDeleted: ((String) -> Void)?
    
    init(photos: [Photo], initialIndex: Int) {
        self.photos = photos
        self.currentPhotoIndex = (0..<photos.count).contains(initialIndex) ? initialIndex : 0
        self.selectedPhotoID = photos[self.currentPhotoIndex].id
        loadFavoriteStates()
    }
    
    var currentPhoto: Photo {
        photos[currentPhotoIndex]
    }
    
    func updateCurrentPhoto(id: String) {
        if let index = photos.firstIndex(where: { $0.id == id }) {
            currentPhotoIndex = index
            selectedPhotoID = id
        }
    }
    
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
    
    func toggleFavorite() {
        withAnimation {
            photos[currentPhotoIndex].isFavorite.toggle()
            
            if photos[currentPhotoIndex].isFavorite {
                CoreDataManager.shared.saveFavoritePhoto(
                    id: photos[currentPhotoIndex].id,
                    image: photos[currentPhotoIndex].image,
                    date: photos[currentPhotoIndex].date,
                    location: photos[currentPhotoIndex].location,
                    assetIdentifier: photos[currentPhotoIndex].asset?.localIdentifier ?? ""
                )
                showFavoriteAnimation = true
            } else {
                CoreDataManager.shared.deleteFavoritePhoto(by: photos[currentPhotoIndex].id)
                showFavoriteAnimation = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.showFavoriteAnimation = false
        }
    }
    
    private func loadFavoriteStates() {
        let favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos()
        
        for i in 0..<photos.count {
            if favoritePhotos.contains(where: { $0.id == photos[i].id }) {
                photos[i].isFavorite = true
            } else {
                photos[i].isFavorite = false
            }
        }
    }
    
    func toggleInfo() {
        withAnimation {
            showInfoView.toggle()
        }
    }
    
    private func fetchAsset(using identifier: String) -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: fetchOptions)
        return fetchResult.firstObject
    }
    
    func toggleDeletePhoto() {
        var assetToDelete = currentPhoto.asset
        if assetToDelete == nil, let identifier = currentPhoto.assetIdentifier {
            assetToDelete = fetchAsset(using: identifier)
        }
        
        if let asset = assetToDelete {
            deleteAsset(asset)
        } else {
            print("Asset 데이터를 찾을 수 없음")
            CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
            self.photos.remove(at: currentPhotoIndex)
            self.shouldDismiss = true
        }
    }

    
    private func deleteAsset(_ asset: PHAsset) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
                    self.shouldDismiss = true
                }
            } else if let error = error {
                print("사진 삭제 중 오류 발생: \(error.localizedDescription)")
            }
        })
    }
    
    private func fetchAssetAndDelete(_ identifier: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: fetchOptions)
        if let asset = fetchResult.firstObject {
            deleteAsset(asset)
        } else {
            CoreDataManager.shared.deleteFavoritePhoto(by: self.currentPhoto.id)
            self.shouldDismiss = true
        }
    }
}
