//
//  FilterScrollView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct EditFilterView: View {
    @StateObject var editFilterViewModel: EditFilterViewModel
    var image: UIImage
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                FilterButton(
                    filterName: "Sepia",
                    filterAction: {
                        editFilterViewModel.applySepiaTone(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CISepiaTone", to: image)
                )
                
                FilterButton(
                    filterName: "Noir",
                    filterAction: {
                        editFilterViewModel.applyNoir(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIPhotoEffectNoir", to: image)
                )
                
                FilterButton(
                    filterName: "Chrome",
                    filterAction: {
                        editFilterViewModel.applyChrome(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIPhotoEffectChrome", to: image)
                )
                
                FilterButton(
                    filterName: "Instant",
                    filterAction: {
                        editFilterViewModel.applyInstant(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIPhotoEffectInstant", to: image)
                )
                
                FilterButton(
                    filterName: "Fade",
                    filterAction: {
                        editFilterViewModel.applyFade(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIPhotoEffectFade", to: image)
                )
                
                FilterButton(
                    filterName: "Mono",
                    filterAction: {
                        editFilterViewModel.applyMonochrome(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIColorMonochrome", to: image)
                )
                
                FilterButton(
                    filterName: "Poster",
                    filterAction: {
                        editFilterViewModel.applyPosterize(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIColorPosterize", to: image)
                )
                
                FilterButton(
                    filterName: "Vignette",
                    filterAction: {
                        editFilterViewModel.applyVignette(to: image)
                    },
                    image: editFilterViewModel.applyPreviewFilter(filterName: "CIVignette", to: image)
                )
            }
            .padding(.horizontal)
        }
    }
}
