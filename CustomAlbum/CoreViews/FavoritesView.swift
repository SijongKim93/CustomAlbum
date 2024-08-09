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
                photos: favoritePhotos,
                columns: columns,
                selectedPhotoIndex: $selectedPhotoIndex,
                animation: animation,
                imageForPhoto: { photoEntity in
                    if let imageData = Data(base64Encoded: photoEntity.image ?? ""),
                       let image = UIImage(data: imageData) {
                        return image
                    }
                    return nil
                }
            )
            .navigationTitle("Favorites")
        }
        .onAppear {
            favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos()
        }
    }
}
