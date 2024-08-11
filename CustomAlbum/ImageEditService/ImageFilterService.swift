//
//  ImageFilterService.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageFilterService {
    private let context = CIContext()

    func applyFilter(_ image: UIImage, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func applySepiaTone(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CISepiaTone")
    }

    func applyNoir(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIPhotoEffectNoir")
    }

    func applyChrome(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIPhotoEffectChrome")
    }

    func applyInstant(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIPhotoEffectInstant")
    }

    func applyFade(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIPhotoEffectFade")
    }
    
    func applyMonochrome(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIColorMonochrome")
    }
    
    func applyPosterize(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIColorPosterize")
    }
    
    func applyVignette(to image: UIImage) -> UIImage? {
        return applyFilter(image, filterName: "CIVignette")
    }
}
