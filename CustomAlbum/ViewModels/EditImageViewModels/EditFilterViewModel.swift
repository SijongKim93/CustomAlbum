




import SwiftUI
import CoreImage

class EditFilterViewModel: ObservableObject {
    @Published var filteredImage: UIImage?
    private let filterService = ImageFilterService()

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

    private func applyFilter(named filterName: String, to image: UIImage) {
        if let filteredImage = filterService.applyFilter(image, filterName: filterName) {
            self.filteredImage = filteredImage
        }
    }

    func resetFilters() {
        filteredImage = nil
    }

    func applyPreviewFilter(filterName: String, to image: UIImage) -> UIImage {
        if let filteredImage = filterService.applyFilter(image, filterName: filterName) {
            return filteredImage
        }
        return image
    }
}
