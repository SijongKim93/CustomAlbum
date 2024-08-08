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
    
    private func setupBindings() {
        permissionManager.$isAuthorized
            .sink { [weak self] isAuthorized in
                guard let self = self else { return }
                self.isAuthorized = isAuthorized
                if isAuthorized {
                    Task {
                        [weak self] in
                        await self?.fetchPhotos()
                    }
                }
            }
            .store(in: &cancellables)
        
        photoLibraryManager.$photos
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchPhotos() async {
        await photoLibraryManager.fetchPhotos()
    }
}
