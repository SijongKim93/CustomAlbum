//
//  ImageCropService.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import UIKit
import CoreImage


class ImageCropService {
    
    // MARK: - 이미지 자르기 메서드
    // CGRect 영역을 기준으로 이미지를 잘라내고, 잘라낸 이미지를 반환합니다.
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    

    // 이미지의 중앙을 기준으로 정사각형 영역을 계산하여 자르기를 수행합니다.
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
