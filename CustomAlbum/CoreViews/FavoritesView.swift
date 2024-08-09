//
//  FavoritesView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
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
                }
            )
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.loadFavoritePhotos()
        }
        .onChange(of: selectedPhotoIndex) { _ in
            viewModel.refreshFavoritePhotos()
        }
    }
}
