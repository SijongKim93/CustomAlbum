//
//  AdjustmentViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

class EditAdjustmentViewModel: ObservableObject {
    @Published var brightness: Double = 0.0
    @Published var contrast: Double = 1.0
    @Published var saturation: Double = 1.0
    @Published var sharpness: Double = 0.5
    @Published var exposure: Double = 0.0
    @Published var vibrance: Double = 0.0
    @Published var highlight: Double = 0.5
    @Published var adjustedImage: UIImage? {
        willSet {
            objectWillChange.send()
        }
    }
    
    private let adjustmentService = AdjustmentService()
    var originalImage: UIImage

    init(image: UIImage) {
        self.originalImage = image
        self.adjustedImage = image
    }

    func applyToCurrentImage() {
        let baseImage = originalImage
        print("Base image: \(baseImage)")
        if let newImage = adjustmentService.applyAdjustments(to: baseImage, brightness: brightness, contrast: contrast, saturation: saturation, sharpness: sharpness, exposure: exposure, vibrance: vibrance, highlight: highlight) {
            print("Adjusted image: \(newImage)")
            DispatchQueue.main.async {
                self.adjustedImage = newImage
                print("adjustedImage updated: \(self.adjustedImage ?? UIImage())")
            }
        } else {
            print("Image adjustment failed")
        }
    }

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
