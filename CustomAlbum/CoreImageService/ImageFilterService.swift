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
    private let context = CIContext() // 이미지 처리에 사용되는 CoreImage 컨텍스트입니다.

    // MARK: - 필터 적용 메서드
    // 필터 이름을 사용해 이미지를 필터링하고, 이미지를 반환합니다.
    func applyFilter(_ image: UIImage, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        // 필터가 적용된 이미지를 출력합니다.
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    // 각 필터 적용을 위한 메서드들은 공통적으로 applyFilter 메서드를 호출하여 필터를 적용합니다.
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
