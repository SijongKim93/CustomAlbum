//
//  PhotoGrid.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct PhotoGrid<PhotoType: Identifiable & Hashable>: View {
    let photos: [PhotoType]
    let columns: [GridItem]
    @Binding var selectedPhotoIndex: Int?
    var animation: Namespace.ID
    var onScrolledToEnd: ((PhotoType) -> Void)?
    var imageForPhoto: (PhotoType) -> UIImage?
    var isFavorite: (PhotoType) -> Bool

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(photos.indices, id: \.self) { index in
                    if let image = imageForPhoto(photos[index]) {
                        PhotoGridItem(
                            photo: image,
                            isSelected: selectedPhotoIndex == index,
                            isFavorite: isFavorite(photos[index])
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            selectedPhotoIndex = index
                        }
                        .matchedGeometryEffect(id: photos[index].id, in: animation)
                        .onAppear {
                            onScrolledToEnd?(photos[index])
                        }
                    }
                }
            }
        }
        .background(Color.primary.colorInvert())
        .navigationDestination(isPresented: Binding(
            get: { selectedPhotoIndex != nil },
            set: { if !$0 { selectedPhotoIndex = nil } }
        )) {
            if let index = selectedPhotoIndex, let image = imageForPhoto(photos[index]) {
                let adjustmentViewModel = EditAdjustmentViewModel(image: image)
                let filterViewModel = EditFilterViewModel()
                let albumViewModel = AlbumViewModel()
                let cropViewModel = EditCropViewModel(image: image)
                let blurViewModel = EditBlurViewModel(image: image)
                let editViewModel = EditImageViewModel(
                    image: image,
                    adjustmentViewModel: adjustmentViewModel,
                    filterViewModel: filterViewModel,
                    cropViewModel: cropViewModel, 
                    albumViewModel: albumViewModel
                )

                FullScreenPhotoView(
                    viewModel: FullScreenPhotoViewModel(photos: photos as! [Photo], initialIndex: index),
                    editViewModel: editViewModel,
                    adjustmentViewModel: adjustmentViewModel,
                    blurViewModel: blurViewModel,
                    filterViewModel: filterViewModel,
                    cropViewModel: cropViewModel
                )
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}
