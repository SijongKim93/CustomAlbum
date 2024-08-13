//
//  EditFilterViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI
import CoreImage


class EditFilterViewModel: ObservableObject {
    @Published var filteredImage: UIImage? // 필터가 적용된 이미지를 저장합니다.
    private let filterService = ImageFilterService() // 필터 적용을 담당하는 서비스를 가져와 사용합니다.

    // MARK: - 필터 적용 메서드들
    
    func applySepiaTone(to image: UIImage) {
        applyFilter(named: "CISepiaTone", to: image)
    }

    func applyNoir(to image: UIImage) {
        applyFilter(named: "CIPhotoEffectNoir", to: image)
    }

    func applyChrome(to image: UIImage) {
        applyFilter(named: "CIPhotoEffectChrome", to: image)
    }

    func applyInstant(to image: UIImage) {
        applyFilter(named: "CIPhotoEffectInstant", to: image)
    }

    func applyFade(to image: UIImage) {
        applyFilter(named: "CIPhotoEffectFade", to: image)
    }

    func applyMonochrome(to image: UIImage) {
        applyFilter(named: "CIColorMonochrome", to: image)
    }

    func applyPosterize(to image: UIImage) {
        applyFilter(named: "CIColorPosterize", to: image)
    }

    func applyVignette(to image: UIImage) {
        applyFilter(named: "CIVignette", to: image)
    }

    // MARK: - 필터 적용 로직
    // CoreImage 필터를 적용하는 공통 로직입니다. 주어진 필터 이름을 사용해 필터를 적용합니다.
    private func applyFilter(named filterName: String, to image: UIImage) {
        if let filteredImage = filterService.applyFilter(image, filterName: filterName) {
            self.filteredImage = filteredImage
        }
    }

    // 모든 필터를 초기화하여 원본 이미지를 복원합니다.
    func resetFilters() {
        filteredImage = nil
    }

    // 미리보기 필터를 적용하여 사용자에게 필터 효과를 미리 보여주는 메서드입니다.
    func applyPreviewFilter(filterName: String, to image: UIImage) -> UIImage {
        if let filteredImage = filterService.applyFilter(image, filterName: filterName) {
            return filteredImage
        }
        return image
    }
}
