//
//  EditActionView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

// EditAction Enum
enum EditAction {
    case filter
    case crop
    case collage
    case portraitMode
}

// EditActionView
struct EditActionView: View {
    @Binding var selectedAction: EditAction?
    @ObservedObject var editViewModel: EditImageViewModel
    
    var body: some View {
        VStack {
            if let action = selectedAction {
                switch action {
                case .filter:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            FilterButton(
                                filterName: "Sepia",
                                filterAction: {
                                    editViewModel.applySepiaTone()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CISepiaTone")
                            )
                            
                            FilterButton(
                                filterName: "Noir",
                                filterAction: {
                                    editViewModel.applyNoir()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIPhotoEffectNoir")
                            )
                            
                            FilterButton(
                                filterName: "Chrome",
                                filterAction: {
                                    editViewModel.applyChrome()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIPhotoEffectChrome")
                            )
                            
                            FilterButton(
                                filterName: "Instant",
                                filterAction: {
                                    editViewModel.applyInstant()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIPhotoEffectInstant")
                            )
                            
                            FilterButton(
                                filterName: "Fade",
                                filterAction: {
                                    editViewModel.applyFade()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIPhotoEffectFade")
                            )
                            
                            FilterButton(
                                filterName: "Mono",
                                filterAction: {
                                    editViewModel.applyMonochrome()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIColorMonochrome")
                            )
                            
                            FilterButton(
                                filterName: "Poster",
                                filterAction: {
                                    editViewModel.applyPosterize()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIColorPosterize")
                            )
                            
                            FilterButton(
                                filterName: "Vignette",
                                filterAction: {
                                    editViewModel.applyVignette()
                                },
                                image: editViewModel.applyPreviewFilter(filterName: "CIVignette")
                            )
                        }
                        .padding(.horizontal)
                    }
                case .crop:
                    Text("자르기 편집 UI")
                case .collage:
                    Text("콜라주 편집 UI")
                case .portraitMode:
                    Text("인물 모드 편집 UI")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .transition(.move(edge: .bottom))
    }
}
