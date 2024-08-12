//
//  BlurViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/12/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class EditBlurViewModel: ObservableObject {
    @Published var bluredImage: UIImage?
    private let context = CIContext()
    private let blurRadius: CGFloat = 10.0
    private var originalImage: UIImage
    
    init(image: UIImage) {
        self.originalImage = image
        self.bluredImage = image
    }
    
    func applyBlur(at point: CGPoint, in imageSize: CGSize, imageFrame: CGRect) {
        guard let editedImage = bluredImage else { return }
        
        // 이미지가 화면에 맞게 조정된 크기 계산
        let adjustedImageWidth = imageSize.width
        let adjustedImageHeight = imageSize.height
        
        // 이미지가 화면에 중앙에 위치하도록 오프셋 계산
        let offsetX = (imageFrame.width - adjustedImageWidth) / 2
        let offsetY = (imageFrame.height - adjustedImageHeight) / 2
        
        // 터치 좌표를 이미지 내 좌표로 변환
        let relativeX = (point.x - offsetX) / adjustedImageWidth
        let relativeY = (point.y - offsetY) / adjustedImageHeight
        
        // 스케일링된 좌표 계산 (Y축 반전 포함)
        let scaledPoint = CGPoint(
            x: relativeX * editedImage.size.width,
            y: (1 - relativeY) * editedImage.size.height  // Y
        )
        
        if let blurredImage = applyBlurToImage(image: editedImage, at: scaledPoint, radius: blurRadius) {
            DispatchQueue.main.async {
                self.bluredImage = blurredImage
            }
        }
    }
    
    private func applyBlurToImage(image: UIImage, at point: CGPoint, radius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = Float(radius)
        
        let maskImage = createMaskImage(for: ciImage.extent.size, at: point, radius: radius)
        
        let maskedImage = ciImage.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputMaskImageKey: maskImage as Any,
            kCIInputImageKey: filter.outputImage ?? ciImage,
            kCIInputBackgroundImageKey: ciImage
        ])
        
        guard let outputImage = context.createCGImage(maskedImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: outputImage)
    }
    
    private func createMaskImage(for size: CGSize, at point: CGPoint, radius: CGFloat) -> CIImage? {
        // 마스크의 중심이 클릭한 위치에 정확히 맞도록 오프셋 조정
        let adjustedX = point.x - radius
        let adjustedY = point.y - radius
        let maskRect = CGRect(x: adjustedX, y: adjustedY, width: radius * 2, height: radius * 2)
        
        let mask = CIFilter.radialGradient()
        mask.center = point
        mask.radius0 = Float(radius)
        mask.radius1 = Float(radius + 1)
        mask.color0 = .white
        mask.color1 = .clear
        
        guard let outputImage = mask.outputImage else { return nil }
        return outputImage.cropped(to: maskRect)
    }
    
    func resetBlur() {
        self.bluredImage = originalImage
    }
}
