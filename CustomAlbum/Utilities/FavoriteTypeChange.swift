//
//  FavoriteTypeChange.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//
import Photos
import UIKit

extension Favorite {
    func toPhoto() -> Photo {
        var asset: PHAsset? = nil
        if let assetIdentifier = self.assetIdentifier {
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
            asset = fetchResult.firstObject
        }
        
        return Photo(
            id: self.id ?? UUID().uuidString,
            image: UIImage(data: Data(base64Encoded: self.image ?? "") ?? Data()) ?? UIImage(),
            date: self.date,
            location: self.location,
            isFavorite: self.isFavorite,
            asset: asset,
            assetIdentifier: self.assetIdentifier
        )
    }
}
