//
//  FavoriteTypeChange.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import UIKit

extension Favorite {
    func toPhoto() -> Photo {
        return Photo(
            id: self.id ?? UUID().uuidString,
            image: UIImage(data: Data(base64Encoded: self.image ?? "") ?? Data()) ?? UIImage(),
            date: self.date,
            location: self.location,
            isFavorite: self.isFavorite
        )
    }
}
