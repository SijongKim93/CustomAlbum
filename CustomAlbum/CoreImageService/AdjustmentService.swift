//
//  AdjustmentService.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/12/24.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


class AdjustmentService {
    private let context = CIContext()

    // MARK: - 이미지 조정 메서드

    func applyAdjustments(to image: UIImage, brightness: Double, contrast: Double, saturation: Double, sharpness: Double, exposure: Double, vibrance: Double, highlight: Double) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return image
        }

        // 기본 색상 조정을 위한 필터입니다.
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = Float(brightness)
        filter.contrast = Float(contrast)
        filter.saturation = Float(saturation)

        let sharpnessFilter = CIFilter.sharpenLuminance()
        sharpnessFilter.inputImage = filter.outputImage
        sharpnessFilter.sharpness = Float(sharpness)
        
        let exposureFilter = CIFilter.exposureAdjust()
        exposureFilter.inputImage = sharpnessFilter.outputImage
        exposureFilter.ev = Float(exposure)

        let vibranceFilter = CIFilter.vibrance()
        vibranceFilter.inputImage = exposureFilter.outputImage
        vibranceFilter.amount = Float(vibrance)

        let highlightFilter = CIFilter.highlightShadowAdjust()
        highlightFilter.inputImage = vibranceFilter.outputImage
        highlightFilter.highlightAmount = Float(highlight)

        // 최종 조정된 이미지를 출력하여 반환합니다.
        guard let outputImage = highlightFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }

        return UIImage(cgImage: cgImage)
    }
}
