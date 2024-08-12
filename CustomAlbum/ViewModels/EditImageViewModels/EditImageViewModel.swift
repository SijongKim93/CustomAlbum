//
//  EditImageViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI
import Photos

class EditImageViewModel: ObservableObject {
    @Published var filterApplied: Bool = false
    @Published var selectedAction: EditAction?
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
    
    func resetEdits() {
        filterViewModel.resetFilters()
        cropViewModel.cropApplied = false
        selectedAction = nil
    }
    
    func applyCropToImage(_ image: UIImage) -> UIImage? {
        return cropViewModel.applyActionCrop(with: cropViewModel.cropRect, imageViewSize: CGSize.zero, to: image)
    }
    
    func saveEditedImage(editedImage: UIImage, completion: @escaping (Bool) -> Void) {
        isSaving = true
        saveError = nil
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: editedImage)
            request.creationDate = Date()
        }) { success, error in
            DispatchQueue.main.async {
                self.isSaving = false
                if success {
                    // 새로운 사진을 photos 배열에 추가
                    let newPhoto = Photo(
                        id: UUID().uuidString,  // 임시 ID, 실제로는 asset의 localIdentifier를 사용해야 합니다
                        image: editedImage,
                        date: Date(),
                        location: nil,  // 필요한 경우 위치 정보를 추가하세요
                        isFavorite: false,
                        asset: nil,  // PHAsset을 가져오는 로직이 필요합니다
                        assetIdentifier: nil  // PHAsset의 localIdentifier를 가져오는 로직이 필요합니다
                    )
                    
                    self.albumViewModel.addNewPhoto(newPhoto)
                    self.albumViewModel.refreshPhotos()
                    completion(true)
                } else if let error = error {
                    self.saveError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Edit Button
    func toggleFilter() {
        selectedAction = selectedAction == .filter ? nil : .filter
    }
    
    func toggleCrop() {
        selectedAction = selectedAction == .crop ? nil : .crop
    }
    
    func toggleAdjustment() {
        if selectedAction == .adjustment {
            selectedAction = nil
        } else {
            filterViewModel.resetFilters()
            selectedAction = .adjustment
        }
    }
    
    func toggleBlur() {
        selectedAction = selectedAction == .blur ? nil : .blur
    }
}
