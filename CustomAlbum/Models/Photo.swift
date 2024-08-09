//
//  Photo.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import UIKit

struct Photo: Identifiable {
    let id: String
    let image: UIImage
    let date: Date?
    let location: String?
    var isFavorite: Bool = false
}

