//
//  PhotoLibraryManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import UIKit
import Photos


class PhotoLibraryManager: ObservableObject {
    @Published var photos: [Photo] = []
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        DispatchQueue.global(qos: .background).async {
            assets.enumerateObjects { (asset, _, _) in
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { image, _ in
                    if let image = image {
                        let date = asset.creationDate
                        let location = self.getLocationString(from: asset)
                        
                        DispatchQueue.main.async {
                            self.photos.append(Photo(id: asset.localIdentifier, image: image, date: date, location: location))
                        }
                    }
                }
            }
        }
    }
    
    private func getLocationString(from asset: PHAsset) -> String? {
        guard let location = asset.location else { return nil }
        
        let geocoder = CLGeocoder()
        var locationString: String?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let country = placemark.country ?? ""
                locationString = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
                if locationString?.isEmpty == true {
                    locationString = nil
                }
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return locationString
    }
}
