//
//  ImageCropService.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import UIKit
import CoreImage

class ImageCropService {
    
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    func cropImageToSquare(_ image: UIImage) -> UIImage? {
        let originalSize = image.size
        let length = min(originalSize.width, originalSize.height)
        let cropRect = CGRect(
            x: (originalSize.width - length) / 2,
            y: (originalSize.height - length) / 2,
            width: length,
            height: length
        )
        return cropImage(image, toRect: cropRect)
    }
}
