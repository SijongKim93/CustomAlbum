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

    func applyAdjustments(to image: UIImage, brightness: Double, contrast: Double, saturation: Double, sharpness: Double, exposure: Double, vibrance: Double, highlight: Double) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            print("CIImage 생성 실패")
            return image
        }

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

        guard let outputImage = highlightFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("Output image 생성 실패")
            return image
        }

        return UIImage(cgImage: cgImage)
    }
}
