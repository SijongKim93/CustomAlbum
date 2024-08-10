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
                FullScreenPhotoView(
                    viewModel: FullScreenPhotoViewModel(
                        photos: viewModel.favoritePhotos,
                        initialIndex: index
                    ),
                    editViewModel: EditImageViewModel(image: viewModel.favoritePhotos[index].image),
                    animation: animation
                )
                .environmentObject(albumViewModel)
                .onDisappear {
                    albumViewModel.refreshPhotos()
                }
            }
        }
    }
}
