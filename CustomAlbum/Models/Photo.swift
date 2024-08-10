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
    var image: UIImage
    var date: Date?
    var location: String?
    var isFavorite: Bool = false
    var asset: PHAsset?
    var assetIdentifier: String?
}

