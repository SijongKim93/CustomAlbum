//
//  EditImageViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

class EditImageViewModel: ObservableObject {
    @Published var filterApplied: Bool = false
    @Published var selectedAction: EditAction?
    @Published var originalImage: UIImage
    @Published var filteredImage: UIImage?
    
    @ObservedObject var adjustmentViewModel: AdjustmentViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    
    init(image: UIImage, adjustmentViewModel: AdjustmentViewModel, filterViewModel: EditFilterViewModel, cropViewModel: EditCropViewModel) {
        self.originalImage = image
        self.adjustmentViewModel = adjustmentViewModel
        self.filterViewModel = filterViewModel
        self.cropViewModel = cropViewModel
    }
    
    func resetEdits() {
        filterViewModel.resetFilters()
        cropViewModel.cropApplied = false
        selectedAction = nil
    }
    
    func applyCropToImage(_ image: UIImage) -> UIImage? {
        return cropViewModel.applyCrop(with: cropViewModel.cropRect, imageViewSize: CGSize.zero, to: image)
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
