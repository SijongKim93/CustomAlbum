//
//  FavoritesView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @EnvironmentObject var albumViewModel: AlbumViewModel
    @StateObject private var viewModel = FavoritesViewModel()
    @Namespace private var animation
    @State private var selectedPhotoIndex: Int?
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            PhotoGrid(
                photos: viewModel.favoritePhotos,
                columns: columns,
                selectedPhotoIndex: $selectedPhotoIndex,
                animation: animation,
                imageForPhoto: { photo in
                    photo.image
                },
                isFavorite: { photo in
                    photo.isFavorite
                }
            )
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.loadFavoritePhotos()
        }
        .onChange(of: selectedPhotoIndex) { newValue, oldValue in
            viewModel.refreshFavoritePhotos()
        }
        .navigationDestination(isPresented: Binding(
            get: { selectedPhotoIndex != nil },
            set: { if !$0 { selectedPhotoIndex = nil } }
        )) {
            if let index = selectedPhotoIndex {
                let selectedImage = viewModel.favoritePhotos[index].image
                let adjustmentViewModel = EditAdjustmentViewModel(image: selectedImage)
                let editFilterViewModel = EditFilterViewModel()
                let cropViewModel = EditCropViewModel(image: selectedImage)
                let editViewModel = EditImageViewModel(
                    image: selectedImage,
                    adjustmentViewModel: adjustmentViewModel,
                    filterViewModel: editFilterViewModel,
                    cropViewModel: cropViewModel, 
                    albumViewModel: albumViewModel
                )
                
                FullScreenPhotoView(
                    viewModel: FullScreenPhotoViewModel(
                        photos: viewModel.favoritePhotos,
                        initialIndex: index
                    ),
                    editViewModel: editViewModel,
                    adjustmentViewModel: adjustmentViewModel,
                    blurViewModel: EditBlurViewModel(image: selectedImage),
                    filterViewModel: editFilterViewModel,
                    cropViewModel: cropViewModel
                )
                .environmentObject(albumViewModel)
            }
        }
    }
}
