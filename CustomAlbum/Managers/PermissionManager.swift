//
//  PermissionManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Photos


class PermissionManager: ObservableObject {
    @Published var isAuthorized = false
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        updateAuthorizationStatus(status)
    }
    
    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.updateAuthorizationStatus(status)
            }
        }
    }
    
    private func updateAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            isAuthorized = true
        case .denied, .restricted, .notDetermined:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }
}
