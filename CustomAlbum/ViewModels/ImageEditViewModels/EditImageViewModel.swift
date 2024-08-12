//
//  EditImageViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI
import CoreImage

class EditImageViewModel: ObservableObject {
    @Published var filterApplied: Bool = false
    @Published var cropApplied: Bool = false
    @Published var selectedAction: EditAction?
    @Published var originalImage: UIImage
    @Published var filteredImage: UIImage?
    @Published var cropRect: CGRect = .zero
    @Published var rotationAngle: CGFloat = 0.0
    
    @ObservedObject var adjustmentViewModel: AdjustmentViewModel
    
    private let filterService = ImageFilterService()
    private let cropService = ImageCropService()
    
    init(image: UIImage, adjustmentViewModel: AdjustmentViewModel) {
        self.originalImage = image
        self.filteredImage = image
        self.adjustmentViewModel = adjustmentViewModel
    }
    
    func resetEdits() {
        filteredImage = originalImage
        filterApplied = false
        cropApplied = false
        rotationAngle = 0.0
        selectedAction = nil
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
            filteredImage = originalImage
            selectedAction = nil
        } else {
            resetFilters()
            selectedAction = .adjustment
        }
    }
    
    func toggleDraw() {
        selectedAction = selectedAction == .blur ? nil : .blur
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
    
    // MARK: - Filter 적용
    
    func applyFilter(named filterName: String) {
        let baseImage = originalImage
        if let filterImage = filterService.applyFilter(baseImage, filterName: filterName) {
            filteredImage = filterImage
            filterApplied = true
        }
    }
    
    private func resetFilters() {
        filterApplied = false
        filteredImage = originalImage
    }
    
    func applyPreviewFilter(filterName: String) -> UIImage {
        if let filteredImage = filterService.applyFilter(originalImage, filterName: filterName) {
            return filteredImage
        }
        return originalImage
    }
    
    // MARK: - Crop 적용
    
    func applyCrop(with rect: CGRect, imageViewSize: CGSize) {
        guard let image = filteredImage else { return }
        let scaleX = image.size.width / imageViewSize.width
        let scaleY = image.size.height / imageViewSize.height
        let scaledCropArea = CGRect(
            x: rect.origin.x * scaleX,
            y: rect.origin.y * scaleY,
            width: rect.size.width * scaleX,
            height: rect.size.height * scaleY
        )
        
        if let croppedCGImage = image.cgImage?.cropping(to: scaledCropArea) {
            filteredImage = UIImage(cgImage: croppedCGImage)
            cropApplied = true
        }
    }
    
    func cropToSquare() {
        if let croppedImage = cropService.cropImageToSquare(originalImage) {
            filteredImage = croppedImage
            cropApplied = true
        }
    }
    
    func resetCrop() {
        cropRect = CGRect(x: 0, y: 0, width: originalImage.size.width, height: originalImage.size.height)
        filteredImage = originalImage
        rotationAngle = 0.0
    }
    
    func setCropAspectRatio(_ aspectRatio: CGFloat, imageViewSize: CGSize) {
        let padding: CGFloat = 20  // 패딩 값을 조절하여 크롭 박스의 크기를 조절할 수 있습니다.
        let maxWidth = imageViewSize.width - (padding * 2)
        let maxHeight = imageViewSize.height - (padding * 2)
        
        var width: CGFloat
        var height: CGFloat
        
        if aspectRatio > 1 {
            width = min(maxWidth, maxHeight * aspectRatio)
            height = width / aspectRatio
        } else {
            height = min(maxHeight, maxWidth / aspectRatio)
            width = height * aspectRatio
        }
        
        cropRect = CGRect(
            x: (imageViewSize.width - width) / 2,
            y: (imageViewSize.height - height) / 2,
            width: width,
            height: height
        )
    }
    
    func setCropBoxToOriginalAspectRatio(imageViewSize: CGSize) {
        cropRect = CGRect(
            x: 0,
            y: 0,
            width: imageViewSize.width,
            height: imageViewSize.height
        )
    }
    
    // MARK: - Rotate 적용
    
    func rotateImageRight() {
        rotationAngle += 90
        if rotationAngle >= 360 { rotationAngle = 0 }
        applyRotation()
    }

    func rotateImageLeft() {
        rotationAngle -= 90
        if rotationAngle < 0 { rotationAngle += 360 }
        applyRotation()
    }

    func applyRotation() {
        guard let cgImage = filteredImage?.cgImage else {
            print("회전 적용 실패: editedImage가 없음")
            return
        }
        let newOrientation: UIImage.Orientation = rotationAngle == 90 ? .right :
        rotationAngle == 180 ? .down :
        rotationAngle == 270 ? .left : .up
        let rotatedImage = UIImage(cgImage: cgImage, scale: filteredImage!.scale, orientation: newOrientation)
        filteredImage = rotatedImage
        print("회전 적용됨: \(rotationAngle)도")
    }
}
