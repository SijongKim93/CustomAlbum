//
//  EditImageViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

class EditImageViewModel: ObservableObject {
    @Published var filterApplied: Bool = false
    @Published var cropApplied: Bool = false
    @Published var collageApplied: Bool = false
    @Published var portraitModeApplied: Bool = false
    @Published var selectedAction: EditAction?
    @Published var originalImage: UIImage
    @Published var editedImage: UIImage?
    
    private let filterService = ImageFilterService()
    
    init(image: UIImage) {
        self.originalImage = image
        self.editedImage = image
    }
    
    // MARK: - Edit Button
    func applyFilter() {
        selectedAction = selectedAction == .filter ? nil : .filter
    }
    
    func applyCrop() {
        selectedAction = selectedAction == .crop ? nil : .crop
    }
    
    func applyCollage() {
        selectedAction = selectedAction == .collage ? nil : .collage
    }
    
    func togglePortraitMode() {
        selectedAction = selectedAction == .portraitMode ? nil : .portraitMode
    }
    
    // MARK: - Filter
    
    func applySepiaTone() {
        applyFilter(named: "CISepiaTone")
    }
    
    func applyNoir() {
        applyFilter(named: "CIPhotoEffectNoir")
    }
    
    func applyChrome() {
        applyFilter(named: "CIPhotoEffectChrome")
    }
    
    func applyInstant() {
        applyFilter(named: "CIPhotoEffectInstant")
    }
    
    func applyFade() {
        applyFilter(named: "CIPhotoEffectFade")
    }
    
    func applyMonochrome() {
        applyFilter(named: "CIColorMonochrome")
    }
    
    func applyPosterize() {
        applyFilter(named: "CIColorPosterize")
    }
    
    func applyVignette() {
        applyFilter(named: "CIVignette")
    }
    
    
    func resetEdits() {
        editedImage = originalImage
        filterApplied = false
        cropApplied = false
        collageApplied = false
        portraitModeApplied = false
    }
    
    // MARK: - Filter 적용
    
    func applyFilter(named filterName: String) {
        if let filteredImage = filterService.applyFilter(originalImage, filterName: filterName) {
            editedImage = filteredImage
            filterApplied = true
        }
    }
    
    func applyPreviewFilter(filterName: String) -> UIImage {
        if let filteredImage = filterService.applyFilter(originalImage, filterName: filterName) {
            return filteredImage
        }
        return originalImage
    }
}
