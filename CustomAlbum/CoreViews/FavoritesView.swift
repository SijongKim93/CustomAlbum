//
//  FavoritesView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @State private var favoritePhotos: [Favorite] = []

    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(favoritePhotos, id: \.self) { photoEntity in
                        if let imageData = Data(base64Encoded: photoEntity.image ?? ""),
                           let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .padding(1)
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos()
        }
    }
}
