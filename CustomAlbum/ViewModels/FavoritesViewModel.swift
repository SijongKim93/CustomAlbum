//
//  FavoritesViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoritePhotos: [Photo] = []

    init() {
        loadFavoritePhotos()
    }

    func loadFavoritePhotos() {
        let favorites = CoreDataManager.shared.fetchFavoritePhotos()
        self.favoritePhotos = favorites.compactMap { $0.toPhoto() }
    }
    
    func refreshFavoritePhotos() {
        loadFavoritePhotos()
    }
}
