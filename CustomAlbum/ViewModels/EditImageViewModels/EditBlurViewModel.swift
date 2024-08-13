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
    @Published var bluredImage: UIImage? // 블러가 적용된 이미지를 저장합니다.
    private let context = CIContext() // Core Image의 처리 컨텍스트를 사용합니다.
    private let blurRadius: CGFloat = 10.0 // 블러의 반경을 설정합니다.
    private var originalImage: UIImage // 편집할 원본 이미지를 저장합니다.
    
    init(image: UIImage) {
        self.originalImage = image
        self.bluredImage = image
    }
    
    // MARK: - 블러 적용
    // 사용자가 터치한 위치에 블러 효과를 적용하는 메서드입니다.
    func applyBlur(at point: CGPoint, in imageSize: CGSize, imageFrame: CGRect) {
        guard let editedImage = bluredImage else { return }
        
        let adjustedImageWidth = imageSize.width
        let adjustedImageHeight = imageSize.height
        
        // 이미지가 화면 중앙에 위치하도록 오프셋을 조정합니다.
        let offsetX = (imageFrame.width - adjustedImageWidth) / 2
        let offsetY = (imageFrame.height - adjustedImageHeight) / 2 - 130
        
        // 터치 좌표를 이미지 내 좌표로 변환합니다.
        let relativeX = (point.x - offsetX) / adjustedImageWidth
        let relativeY = (point.y - offsetY) / adjustedImageHeight
        
        // 이미지 내 실제 좌표를 계산합니다.
        let scaledPoint = CGPoint(
            x: relativeX * editedImage.size.width,
            y: (1 - relativeY) * editedImage.size.height
        )
        
        // 블러를 적용하고 결과 이미지를 업데이트합니다.
        if let blurredImage = applyBlurToImage(image: editedImage, at: scaledPoint, radius: blurRadius) {
            DispatchQueue.main.async {
                self.bluredImage = blurredImage
            }
        }
    }
    
    // MARK: - 블러 필터 적용
    // Core Image를 사용하여 주어진 위치에 블러 필터를 적용하는 메서드입니다.
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
    
    // 블러를 적용할 영역을 지정하는 마스크 이미지를 생성하는 메서드입니다.
    private func createMaskImage(for size: CGSize, at point: CGPoint, radius: CGFloat) -> CIImage? {
        // 마스크의 중심이 정확히 클릭한 위치에 오도록 오프셋을 조정합니다.
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
    
    // 블러 효과를 초기화하여 원본 이미지로 되돌립니다.
    func resetBlur() {
        self.bluredImage = originalImage
    }
}
