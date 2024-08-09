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
        favoritePhotos = CoreDataManager.shared.fetchFavoritePhotos().map { $0.toPhoto() }
    }

    func refreshFavoritePhotos() {
        loadFavoritePhotos()
    }
}
