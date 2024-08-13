//
//  PermissionManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Photos


class PermissionManager: ObservableObject {
    @Published var isAuthorized = false
    
    // 사진 라이브러리 접근 권한을 확인합니다.
    func checkPhotoLibraryPermission() async {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        await updateAuthorizationStatus(status)
    }
    
    // 사진 라이브러리 접근 권한을 요청합니다.
    func requestPhotoLibraryPermission() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        await updateAuthorizationStatus(status)
    }
    
    
    // 권한 상태를 업데이트합니다.
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
