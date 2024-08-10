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
    @Published var photos: [Photo] = []
    @Published var isAuthorized = false
    
    private let photoLibraryManager = PhotoLibraryManager()
    private let permissionManager = PermissionManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    func checkAndRequestPermission() {
        Task {
            await permissionManager.checkPhotoLibraryPermission()
            if !isAuthorized {
                await permissionManager.requestPhotoLibraryPermission()
            }
        }
    }
    
    func requestPermission() {
        Task {
            await permissionManager.requestPhotoLibraryPermission()
        }
    }
    
    func fetchPhotosIfAuthorized() {
        if isAuthorized {
            Task {
                await fetchPhotos()
            }
        }
    }
    
    func loadMoreIfNeeded(currentItem: Photo?) {
        guard let item = currentItem, !photos.isEmpty else { return }
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        if photos.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            Task {
                await fetchPhotos()
            }
        }
    }
    
    private func setupBindings() {
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
        
        photoLibraryManager.$photos
            .receive(on: DispatchQueue.main)
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchPhotos() async {
        await photoLibraryManager.fetchPhotos()
    }
    
    func removePhoto(by id: String) {
        if let index = photos.firstIndex(where: { $0.id == id }) {
            CoreDataManager.shared.deleteFavoritePhoto(by: id)
            photos.remove(at: index)
        }
    }
    
    func refreshPhotos() {
        Task {
            await fetchPhotos()
        }
    }
}
