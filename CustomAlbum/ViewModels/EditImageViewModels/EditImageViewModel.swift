//
//  EditImageViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI
import Photos


class EditImageViewModel: ObservableObject {
    @Published var filterApplied: Bool = false // 필터가 적용되었는지를 나타내는 플래그입니다.
    @Published var selectedAction: EditAction? // 현재 선택된 편집 작업을 저장합니다.
    @Published var originalImage: UIImage
    @Published var filteredImage: UIImage?
    @Published var isSaving: Bool = false
    @Published var saveError: String?
    
    @ObservedObject var adjustmentViewModel: EditAdjustmentViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @ObservedObject var albumViewModel: AlbumViewModel
    
    init(image: UIImage, adjustmentViewModel: EditAdjustmentViewModel, filterViewModel: EditFilterViewModel, cropViewModel: EditCropViewModel, albumViewModel: AlbumViewModel) {
        self.originalImage = image
        self.adjustmentViewModel = adjustmentViewModel
        self.filterViewModel = filterViewModel
        self.cropViewModel = cropViewModel
        self.albumViewModel = albumViewModel
    }
    
    // MARK: - 편집 초기화
    
    // 사용자가 모든 편집을 초기화할 때 호출됩니다.
    func resetEdits() {
        filterViewModel.resetFilters() // 모든 필터를 초기화합니다.
        cropViewModel.cropApplied = false // 자르기 상태를 초기화합니다.
        selectedAction = nil // 선택된 작업을 초기화합니다.
    }
    
    // MARK: - 이미지 자르기 적용
    
    // 자르기가 적용된 이미지를 반환합니다.
    func applyCropToImage(_ image: UIImage) -> UIImage? {
        return cropViewModel.applyActionCrop(with: cropViewModel.cropRect, imageViewSize: CGSize.zero, to: image)
    }
    
    // MARK: - 이미지 저장
    
    func saveEditedImage(editedImage: UIImage, completion: @escaping (Bool) -> Void) {
        isSaving = true // 저장 작업이 시작되었음을 표시합니다.
        saveError = nil // 이전 오류 메시지를 초기화합니다.
        
        // PHPhotoLibrary를 통해 이미지를 저장합니다.
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: editedImage)
            request.creationDate = Date()
        }) { success, error in
            DispatchQueue.main.async {
                self.isSaving = false
                if success {
                    let newPhoto = Photo(
                        id: UUID().uuidString,
                        image: editedImage,
                        date: Date(),
                        location: nil,
                        isFavorite: false,
                        asset: nil,
                        assetIdentifier: nil
                    )
                    
                    self.albumViewModel.addNewPhoto(newPhoto) // 사진을 앨범에 추가합니다.
                    self.albumViewModel.refreshPhotos() // 앨범의 사진 목록을 새로고침합니다.
                    completion(true)
                } else if let error = error {
                    self.saveError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Edit Button 토글
    
    // 필터 버튼을 누를 때 호출됩니다.
    func toggleFilter() {
        selectedAction = selectedAction == .filter ? nil : .filter
    }
    
    // 자르기 버튼을 누를 때 호출됩니다.
    func toggleCrop() {
        selectedAction = selectedAction == .crop ? nil : .crop
    }
    
    // 조정 버튼을 누를 때 호출됩니다.
    func toggleAdjustment() {
        if selectedAction == .adjustment {
            selectedAction = nil
        } else {
            filterViewModel.resetFilters() // 필터를 초기화해 조정 작업과 충돌하지 않도록 합니다.
            selectedAction = .adjustment
        }
    }
    
    // 블러 버튼을 누를 때 호출됩니다.
    func toggleBlur() {
        selectedAction = selectedAction == .blur ? nil : .blur
    }
}
