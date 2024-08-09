//
//  FavoritesView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FullScreenPhotoViewModel(photos: AlbumViewModel().photos, initialIndex: 0)
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(viewModel.photos.filter { $0.isFavorite }) { photo in
                        Image(uiImage: photo.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(1)
            }
            .navigationTitle("Favorites")
        }
    }
}
