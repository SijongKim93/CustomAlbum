//
//  EditCropViewModel.swift
//  CustomAlbum
//
//  
//

import SwiftUI

class EditCropViewModel: ObservableObject {
    @Published var cropRect: CGRect = .zero
    @Published var cropApplied: Bool = false
    @Published var rotationAngle: CGFloat = 0.0
    @Published var isCropBoxVisible: Bool = true
    @Published var croppedImage: UIImage?
    var image: UIImage
    
    private let cropService = ImageCropService()
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyCrop(with rect: CGRect, imageViewSize: CGSize, to image: UIImage) -> UIImage? {
        let scaleX = image.size.width / imageViewSize.width
        let scaleY = image.size.height / imageViewSize.height
        let scaledCropArea = CGRect(
            x: rect.origin.x * scaleX,
            y: rect.origin.y * scaleY,
            width: rect.size.width * scaleX,
            height: rect.size.height * scaleY
        )
        
        if let croppedCGImage = image.cgImage?.cropping(to: scaledCropArea) {
            cropApplied = true
            return UIImage(cgImage: croppedCGImage)
        }
        return image
    }
    
    func cropToSquare(_ image: UIImage) -> UIImage? {
        if let croppedImage = cropService.cropImageToSquare(image) {
            cropApplied = true
            return croppedImage
        }
        return image
    }
    
    func resetCrop(to originalImage: UIImage) {
        cropRect = CGRect(x: 0, y: 0, width: originalImage.size.width, height: originalImage.size.height)
        rotationAngle = 0.0
    }
    
    func setCropAspectRatio(_ aspectRatio: CGFloat, imageViewSize: CGSize) {
        let padding: CGFloat = 20
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
    
    func applyCrop(imageViewSize: CGSize) {
        if let croppedImage = crop(image: image, cropArea: cropRect, imageViewSize: imageViewSize) {
            self.croppedImage = croppedImage
            self.cropApplied = true
            self.isCropBoxVisible = false
        }
    }
    
    func resetCropBox(imageViewSize: CGSize) {
        setCropBoxToOriginalAspectRatio(imageViewSize: imageViewSize)
        self.cropApplied = false
        self.isCropBoxVisible = true
        self.croppedImage = nil
    }
    
    private func crop(image: UIImage, cropArea: CGRect, imageViewSize: CGSize) -> UIImage? {
        let scaleX = image.size.width / imageViewSize.width * image.scale
        let scaleY = image.size.height / imageViewSize.height * image.scale
        let scaledCropArea = CGRect(
            x: cropArea.origin.x * scaleX,
            y: cropArea.origin.y * scaleY,
            width: cropArea.size.width * scaleX,
            height: cropArea.size.height * scaleY
        )
        
        guard let cutImageRef: CGImage = image.cgImage?.cropping(to: scaledCropArea) else {
            return nil
        }
        
        return UIImage(cgImage: cutImageRef)
    }
    
    func initializeCropBox(for imageSize: CGSize, in viewSize: CGSize) {
        let imageAspectRatio = imageSize.width / imageSize.height
        let viewAspectRatio = viewSize.width / viewSize.height
        
        var cropWidth: CGFloat
        var cropHeight: CGFloat
        
        if imageAspectRatio > viewAspectRatio {
            cropWidth = viewSize.width
            cropHeight = viewSize.width / imageAspectRatio
        } else {
            
            cropHeight = viewSize.height
            cropWidth = viewSize.height * imageAspectRatio
        }
        
        let x = (viewSize.width - cropWidth) / 2
        let y = (viewSize.height - cropHeight) / 2
        
        self.cropRect = CGRect(x: x, y: y, width: cropWidth, height: cropHeight)
        self.isCropBoxVisible = true
    }
    
    // MARK: - Rotate 적용
    
    func rotateImageRight(_ image: UIImage) -> UIImage? {
        rotationAngle += 90
        if rotationAngle >= 360 { rotationAngle = 0 }
        return applyRotation(to: image)
    }

    func rotateImageLeft(_ image: UIImage) -> UIImage? {
        rotationAngle -= 90
        if rotationAngle < 0 { rotationAngle += 360 }
        return applyRotation(to: image)
    }

    func applyRotation(to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
            print("회전 적용 실패: filteredImage가 없음")
            return nil
        }
        let newOrientation: UIImage.Orientation = rotationAngle == 90 ? .right :
        rotationAngle == 180 ? .down :
        rotationAngle == 270 ? .left : .up
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: newOrientation)
    }
}
