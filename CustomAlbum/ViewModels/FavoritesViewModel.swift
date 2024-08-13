//
//  FavoritesViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI


class FavoritesViewModel: ObservableObject {
    @Published var favoritePhotos: [Photo] = [] // 즐겨찾기한 사진 목록을 저장하는 배열입니다.


    init() {
        loadFavoritePhotos()
    }

    // CoreData에서 즐겨찾기 사진을 불러와 favoritePhotos 배열에 저장합니다.
    func loadFavoritePhotos() {
        let favorites = CoreDataManager.shared.fetchFavoritePhotos()
        self.favoritePhotos = favorites.compactMap { $0.toPhoto() } // CoreData의 엔티티를 Photo 객체로 변환하여 저장합니다.
    }
    
    // 즐겨찾기 사진 목록을 새로고침합니다.
    func refreshFavoritePhotos() {
        loadFavoritePhotos()
    }
}
