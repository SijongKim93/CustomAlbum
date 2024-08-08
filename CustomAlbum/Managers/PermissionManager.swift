//
//  PermissionManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Photos


class PermissionManager: ObservableObject {
    @Published var isAuthorized = false
    
    func checkPhotoLibraryPermission() async {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        await updateAuthorizationStatus(status)
    }
    
    func requestPhotoLibraryPermission() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        await updateAuthorizationStatus(status)
    }
    
    @MainActor
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
