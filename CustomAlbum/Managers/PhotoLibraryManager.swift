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
            let group = DispatchGroup()
            var newPhotos: [Photo] = []
            
            assets.enumerateObjects { (asset, _, _) in
                group.enter()
                self.getPhotoInfo(for: asset) { photo in
                    if let photo = photo {
                        newPhotos.append(photo)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.photos = newPhotos.sorted { $0.date ?? Date.distantPast > $1.date ?? Date.distantPast}
            }
        }
    }
    
    private func getPhotoInfo(for asset: PHAsset, completion: @escaping (Photo?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        let scale = UIScreen.main.scale
        let screenWidth = UIScreen.main.bounds.width
        let targetSize = CGSize(width: screenWidth * scale / 3, height: screenWidth * scale / 3)
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            guard let image = image else {
                completion(nil)
                return
            }
            
            self.getLocationString(from: asset) { location in
                let photo = Photo(id: asset.localIdentifier, image: image, date: asset.creationDate, location: location)
                completion(photo)
            }
        }
    }
    
    private func getLocationString(from asset: PHAsset, completion: @escaping (String?) -> Void) {
        guard let location = asset.location else {
            completion(nil)
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let country = placemark.country ?? ""
                let locationString = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
                completion(locationString.isEmpty ? nil : locationString)
            } else {
                completion(nil)
            }
        }
    }
}
