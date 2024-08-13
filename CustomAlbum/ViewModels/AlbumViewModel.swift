//
//  AlbumViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Foundation
import Combine
import Photos


class AlbumViewModel: ObservableObject {
    @Published var photos: [Photo] = [] // 사진 데이터를 저장하는 배열로, UI에 바인딩되어 데이터가 변경될 때마다 UI가 자동으로 업데이트됩니다.
    @Published var isAuthorized = false // 사진 라이브러리 접근 권한 상태를 저장합니다.
    @Published var showAlert = false // 알림창 표시 여부를 제어합니다.
    @Published var alertMessage = "" // 알림창에 표시할 메시지를 저장합니다.
    
    // 사진 라이브러리 매니저와 권한 매니저를 인스턴스화하여 사용합니다.
    private let photoLibraryManager = PhotoLibraryManager()
    private let permissionManager = PermissionManager()
    
    // Combine의 AnyCancellable 타입을 설정했습니다.
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    // MARK: - 권한 확인 및 요청
    
    // 사용자가 사진 라이브러리에 접근할 수 있는 권한이 있는지 확인하고, 없으면 권한을 요청합니다.
    // 비동기로 권한 상태를 확인하고, 필요한 경우 권한을 요청하는 작업을 수행합니다.
    
    func checkAndRequestPermission() {
        Task {
            await permissionManager.checkPhotoLibraryPermission()
            if isAuthorized {
                await fetchPhotos()
            } else {
                await permissionManager.requestPhotoLibraryPermission()
                if isAuthorized {
                    await fetchPhotos()
                }
            }
        }
    }
    
    // 사용자가 권한 요청을 할 때 호출되는 메서드입니다.
    func requestPermission() {
        Task {
            await permissionManager.requestPhotoLibraryPermission()
        }
    }
    
    // 사용자가 사진 라이브러리에 접근할 수 있는 권한이 있을 때만 사진을 가져옵니다.
    // 권한이 확인되면 비동기로 사진을 가져옵니다.
    func fetchPhotosIfAuthorized() {
        if isAuthorized {
            Task {
                await fetchPhotos()
            }
        }
    }
    
    // MARK: - 페이지네이션
    
    // 스크롤이 끝에 도달했을 때 추가로 사진을 로드하는 로직을 담당합니다.
    // 페이징을 통해 앨범에 있는 대량의 사진을 한 번에 로드하지 않도록 처리합니다.
    func loadMoreIfNeeded(currentItem: Photo?) {
        guard let item = currentItem, !photos.isEmpty else { return }
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        // 현재 스크롤 위치가 인덱스에 도달했는지 확인합니다.
        if photos.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            Task {
                await fetchPhotos()
            }
        }
    }
    
    // MARK: - 바인딩 설정
    
    /*
     권한 상태 변경될 때 sink를 사용한 이유는 권한 값이 변경될 때 마다 값을 받아와 
     isAuthorized를 업데이트하고 호출해야하는 여러가지 논리적 제어가 필요하기 때문에 sink를 사용했습니다.
     
     photoLibraryManager를 통해 사진을 가져오는 부분은 단순 사진을 가져와 photos 속성에 할당하는 단순한 역할만 수행하기 때문에 assign을 사용했습니다.
     */
    private func setupBindings() {
        // 권한 상태가 변경될 때 UI에 반영하도록 바인딩합니다.
        permissionManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthorized in
                guard let self = self else { return }
                self.isAuthorized = isAuthorized
                if isAuthorized {
                    self.fetchPhotosIfAuthorized()
                }
            }
            .store(in: &cancellables)
        
        // 사진 라이브러리 매니저에서 가져온 사진 데이터를 ViewModel의 photos 배열에 할당합니다.
        photoLibraryManager.$photos
            .receive(on: DispatchQueue.main)
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - 사진 데이터 페칭
    
    // 사진 라이브러리 매니저를 통해 사진을 비동기로 가져옵니다.
    private func fetchPhotos() async {
        await photoLibraryManager.fetchPhotos()
    }
    
    // MARK: - 사진 삭제
    
    // 특정 사진을 삭제하는 메서드입니다. CoreData와 사진에서 모두 삭제할 수 있습니다.
    @MainActor
    func removePhoto(by id: String, deleteFromCoreData: Bool = true) {
        // ViewModel의 photos 배열에서 해당 사진을 제거합니다.
        if let index = photos.firstIndex(where: { $0.id == id }) {
            photos.remove(at: index)
        }
        
        // CoreData에서도 사진을 삭제해야 하는 경우 처리합니다.
        if deleteFromCoreData {
            CoreDataManager.shared.deleteFavoritePhoto(by: id)
            
            // 사진 라이브러리에서도 사진을 삭제합니다.
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
                }) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            self.refreshPhotos()
                        }
                    } else if let error = error {
                        DispatchQueue.main.async {
                            self.alertMessage = "사진 삭제 중 오류 발생: \(error.localizedDescription)"
                            self.showAlert = true
                        }
                    }
                }
            }
        } else {
            // CoreData에서만 삭제할 때도 UI를 갱신합니다.
            DispatchQueue.main.async {
                self.refreshPhotos()
            }
        }
    }
    
    // MARK: - 사진 새로고침
    
    // 현재 로드된 사진 데이터를 새로 고칩니다.
    @MainActor
    func refreshPhotos() {
        Task {
            await fetchPhotos()
            updateFavoriteStates()
        }
    }
    
    // MARK: - 즐겨찾기 상태 업데이트
    
    // Core Data에서 즐겨찾기 상태를 확인하여 ViewModel의 photos 배열에 반영합니다.
    private func updateFavoriteStates() {
        let favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos()
        // 현재 로드된 모든 사진에 대해, 즐겨찾기 상태를 확인하여 업데이트합니다.
        for i in 0..<photos.count {
            photos[i].isFavorite = favoritePhotos.contains { $0.id == photos[i].id }
        }
    }
    
    // MARK: - 새로운 사진 추가
    
    // 새로 가져온 사진을 ViewModel의 photos 배열에 추가합니다.
    func addNewPhoto(_ photo: Photo) {
        DispatchQueue.main.async {
            // 사진을 배열의 맨 앞에 추가합니다.
            self.photos.insert(photo, at: 0)
        }
    }
}
