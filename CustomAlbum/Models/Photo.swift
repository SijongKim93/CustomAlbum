//
//  Photo.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import UIKit
import Photos

struct Photo: Identifiable, Hashable {
    let id: String
    let image: UIImage
    let date: Date?
    let location: String?
    var isFavorite: Bool = false
    let asset: PHAsset?
}

