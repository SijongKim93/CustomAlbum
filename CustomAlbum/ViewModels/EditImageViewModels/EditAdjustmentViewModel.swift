//
//  EditAdjustmentViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI


class EditAdjustmentViewModel: ObservableObject {
    @Published var brightness: Double = 0.0 // 밝기 조정 값을 저장합니다.
    @Published var contrast: Double = 1.0 // 대비 조정 값을 저장합니다.
    @Published var saturation: Double = 1.0 // 채도 조정 값을 저장합니다.
    @Published var sharpness: Double = 0.5 // 선명도 조정 값을 저장합니다.
    @Published var exposure: Double = 0.0 // 노출 조정 값을 저장합니다.
    @Published var vibrance: Double = 0.0 // 생동감 조정 값을 저장합니다.
    @Published var highlight: Double = 0.5 // 하이라이트 조정 값을 저장합니다.
    @Published var adjustedImage: UIImage?
    
    private let adjustmentService = AdjustmentService() // 조정 작업을 담당하는 서비스 클래스를 가져옵니다.
    var originalImage: UIImage

    init(image: UIImage) {
        self.originalImage = image
        self.adjustedImage = image
    }

    // MARK: - 이미지 조정 적용
    // 사용자가 설정한 조정 값을 바탕으로 이미지를 조정하고, 조정된 이미지를 저장합니다.
    func applyToCurrentImage() {
        let baseImage = originalImage
        if let newImage = adjustmentService.applyAdjustments(to: baseImage, brightness: brightness, contrast: contrast, saturation: saturation, sharpness: sharpness, exposure: exposure, vibrance: vibrance, highlight: highlight) {
            DispatchQueue.main.async {
                self.adjustedImage = newImage
            }
        }
    }

    // 모든 조정 값을 초기화하고, 원본 이미지로 되돌립니다.
    func resetAdjustments(updateImage: Bool = true) {
        brightness = 1.0
        contrast = 1.0
        saturation = 1.0
        sharpness = 0.5
        exposure = 0.0
        vibrance = 0.0
        highlight = 0.5

        if updateImage {
            adjustedImage = originalImage
        }
    }
}
