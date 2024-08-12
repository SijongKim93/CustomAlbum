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
