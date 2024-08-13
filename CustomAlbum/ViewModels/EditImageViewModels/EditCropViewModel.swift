//
//  EditCropViewModel.swift
//  CustomAlbum
//
//  
//

import SwiftUI


class EditCropViewModel: ObservableObject {
    @Published var cropRect: CGRect = .zero // 자르기 영역을 나타내는 CGRect입니다.
    @Published var cropApplied: Bool = false // 자르기 작업이 적용되었는지 여부를 나타냅니다.
    @Published var rotationAngle: CGFloat = 0.0 // 이미지의 회전 각도를 나타냅니다.
    @Published var isCropBoxVisible: Bool = true // 자르기 박스가 보이는지 여부를 나타냅니다.
    @Published var croppedImage: UIImage? // 자르기 작업이 적용된 이미지를 저장합니다.
    var image: UIImage
    
    private let cropService = ImageCropService() // 자르기 작업을 담당하는 서비스를 가져와 사용합니다.
    
    init(image: UIImage) {
        self.image = image
    }
    
    // MARK: - 자르기 적용
    // 자르기 작업을 수행 후, 자른 이미지를 반환합니다.
    func applyActionCrop(with rect: CGRect, imageViewSize: CGSize, to image: UIImage) -> UIImage? {
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
    
    // 이미지를 정사각형으로 자르는 메서드입니다.
    func cropToSquare(_ image: UIImage) -> UIImage? {
        if let croppedImage = cropService.cropImageToSquare(image) {
            cropApplied = true
            return croppedImage
        }
        return image
    }
    
    // 자르기 작업을 초기 상태로 되돌립니다.
    func resetCrop(to originalImage: UIImage) {
        cropRect = CGRect(x: 0, y: 0, width: originalImage.size.width, height: originalImage.size.height)
        rotationAngle = 0.0
    }
    
    // 자르기 박스의 비율을 설정하고, 화면 크기에 맞게 조정합니다.
    func setCropAspectRatio(_ aspectRatio: CGFloat, imageViewSize: CGSize) {
        let padding: CGFloat = 20
        let maxWidth = imageViewSize.width - (padding * 2)
        let maxHeight = imageViewSize.height - (padding * 2)
        
        var width: CGFloat
        var height: CGFloat
        
        if (aspectRatio > 1) {
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
    
    // 자르기 박스를 원래의 비율로 설정합니다.
    func setCropBoxToOriginalAspectRatio(imageViewSize: CGSize) {
        cropRect = CGRect(
            x: 0,
            y: 0,
            width: imageViewSize.width,
            height: imageViewSize.height
        )
    }
    
    // 자르기 작업을 적용하고, 자른 이미지를 저장합니다.
    func applyCrop(imageViewSize: CGSize) {
        if let croppedImage = crop(image: image, cropArea: cropRect, imageViewSize: imageViewSize) {
            self.croppedImage = croppedImage
            self.cropApplied = true
            self.isCropBoxVisible = false
        }
    }
    
    // 자르기 박스를 초기화하고, 자르기 작업을 되돌립니다.
    func resetCropBox(imageViewSize: CGSize) {
        setCropBoxToOriginalAspectRatio(imageViewSize: imageViewSize)
        self.cropApplied = false
        self.isCropBoxVisible = true
        self.croppedImage = nil
    }
    
    // 이미지 자르기 작업을 수행하는 내부 메서드입니다.
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
    
    // 자르기 박스를 이미지 크기에 맞게 초기화합니다.
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
    
    // MARK: - 이미지 회전 적용
    
    // 이미지를 오른쪽으로 90도 회전시키는 메서드입니다.
    func rotateImageRight(_ image: UIImage) -> UIImage? {
        rotationAngle += 90
        if rotationAngle >= 360 { rotationAngle = 0 }
        return applyRotation(to: image)
    }

    // 이미지를 왼쪽으로 90도 회전시키는 메서드입니다.
    func rotateImageLeft(_ image: UIImage) -> UIImage? {
        rotationAngle -= 90
        if rotationAngle < 0 { rotationAngle += 360 }
        return applyRotation(to: image)
    }

    // 이미지의 회전을 적용하는 내부 메서드입니다.
    func applyRotation(to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        let newOrientation: UIImage.Orientation = rotationAngle == 90 ? .right :
        rotationAngle == 180 ? .down :
        rotationAngle == 270 ? .left : .up
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: newOrientation)
    }
}
