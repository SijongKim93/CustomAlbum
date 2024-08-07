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
        permissionManager.checkPhotoLibraryPermission()
        if !isAuthorized {
            permissionManager.requestPhotoLibraryPermission()
        }
    }
    
    func requestPermission() {
        permissionManager.requestPhotoLibraryPermission()
    }
    
    private func setupBindings() {
        permissionManager.$isAuthorized
            .sink { [weak self] isAuthorized in
                self?.isAuthorized = isAuthorized
                if isAuthorized {
                    self?.fetchPhotos()
                }
            }
            .store(in: &cancellables)
        
        photoLibraryManager.$photos
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchPhotos() {
        photoLibraryManager.fetchPhotos()
    }
}
