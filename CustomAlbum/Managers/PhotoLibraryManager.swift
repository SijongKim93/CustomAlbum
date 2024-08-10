//
//  PhotoLibraryManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//


import UIKit
import Photos
import CoreLocation

class PhotoLibraryManager: ObservableObject {
    @Published var photos: [Photo] = []
    private var lastFetchIndex: Int = 0
    private let fetchLimit = 50
    private var isFetching = false
    private var hasMorePhotos = true
    private let imageManager = PHCachingImageManager()
    
    func fetchPhotos() async {
        guard !isFetching && hasMorePhotos else { return }
        isFetching = true
        
        imageManager.stopCachingImagesForAllAssets()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        guard assets.count > 0 && lastFetchIndex < assets.count else {
            await MainActor.run {
                hasMorePhotos = false
                isFetching = false
            }
            return
        }
        
        let endIndex = min(lastFetchIndex + fetchLimit, assets.count)
        
        let newPhotos: [Photo] = await withTaskGroup(of: Photo?.self) { group -> [Photo] in
            for index in lastFetchIndex..<endIndex {
                let asset = assets.object(at: index)
                group.addTask {
                    return await self.getPhotoInfo(for: asset)
                }
            }
            
            var photos: [Photo] = []
            for await photo in group {
                if let photo = photo {
                    photos.append(photo)
                }
            }
            return photos
        }
        
        await MainActor.run {
            let newUniquePhotos = newPhotos.filter { newPhoto in
                !self.photos.contains(where: { $0.id == newPhoto.id })
            }
            self.photos.append(contentsOf: newUniquePhotos)
            lastFetchIndex = endIndex
            hasMorePhotos = endIndex < assets.count
            isFetching = false
        }
    }
    
    private func getPhotoInfo(for asset: PHAsset) async -> Photo? {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        let scale =  await UIScreen.main.scale
        let screenWidth =  await UIScreen.main.bounds.width
        let targetSize = CGSize(width: screenWidth * scale / 3, height: screenWidth * scale / 3)
        
        let image = await requestImage(for: asset, targetSize: targetSize, options: options)
        let location = await getLocationString(from: asset)
        
        guard let image = image else { return nil }
        
        return Photo(id: asset.localIdentifier, image: image, date: asset.creationDate, location: location, asset: asset,
                     assetIdentifier: asset.localIdentifier)
    }
    
    private func requestImage(for asset: PHAsset, targetSize: CGSize, options: PHImageRequestOptions) async -> UIImage? {
        await withCheckedContinuation { continuation in
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    private func getLocationString(from asset: PHAsset) async -> String? {
        guard let location = asset.location else { return nil }
        
        return await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    let locationString = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
                    continuation.resume(returning: locationString.isEmpty ? nil : locationString)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
