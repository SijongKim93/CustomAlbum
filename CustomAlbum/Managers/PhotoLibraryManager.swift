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
    // @Published를 사용하여 사진 목록이 변경될 때 UI가 자동으로 업데이트됩니다.
    @Published var photos: [Photo] = []
    
    // 페이징 처리를 위한 변수
    private var lastFetchIndex: Int = 0  // 마지막으로 페치한 인덱스
    private let fetchLimit = 50  // 한 번에 가져올 사진의 개수
    private var isFetching = false  // 중복 페치를 방지하기 위한 플래그
    private var hasMorePhotos = true  // 더 가져올 사진이 있는지 여부
    
    // 이미지 캐싱을 위한 PHCachingImageManager 사용
    private let imageManager = PHCachingImageManager()
    
    // MARK: - 사진 불러오기
    
    /*
     withTaskGroup를 사용해 비동기로 사진을 가져와 Photo 배열에 추가합니다.
     디바이스로 확인 시 대량의 앨범 사진으로 인해 앱이 과부화 되는 이슈가 확인되어
     스크롤 시 50장씩 데이터를 로드하는 페이지 네이션 활용해 이슈 해결했습니다.
     */
    func fetchPhotos() async {
        // 이미 페치 중이거나 더 가져올 사진이 없는 경우 메서드를 종료합니다.
        guard !isFetching && hasMorePhotos else { return }
        isFetching = true
        
        // 이전에 캐싱된 이미지를 모두 초기화합니다.
        imageManager.stopCachingImagesForAllAssets()
        
        // PHFetchOptions를 사용하여 앨범의 사진을 최신순으로 정렬합니다.
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // fetchAssets 메서드를 사용해 앨범의 모든 이미지를 가져옵니다.
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // 더 이상 가져올 사진이 없거나 모든 사진을 다 불러왔으면 작업을 종료합니다.
        guard assets.count > 0 && lastFetchIndex < assets.count else {
            await MainActor.run {
                hasMorePhotos = false
                isFetching = false
            }
            return
        }
        
        // 페치할 사진의 범위를 설정합니다. 이 범위는 마지막으로 페치한 인덱스부터 시작해 fetchLimit 만큼 증가합니다.
        let endIndex = min(lastFetchIndex + fetchLimit, assets.count)
        
        // withTaskGroup을 사용해 비동기적으로 Asset의 사진을 불러옵니다.
        let newPhotos: [Photo] = await withTaskGroup(of: Photo?.self) { group -> [Photo] in
            for index in lastFetchIndex..<endIndex {
                let asset = assets.object(at: index)
                group.addTask {
                    return await self.getPhotoInfo(for: asset)
                }
            }
            
            // 그룹 작업에서 반환된 각 사진 정보를 배열에 저장합니다.
            var photos: [Photo] = []
            for await photo in group {
                if let photo = photo {
                    photos.append(photo)
                }
            }
            return photos
        }
        
        // 메인 스레드에서 UI 업데이트를 위해 새로 불러온 사진을 기존 배열에 추가하고 정렬합니다.
        await MainActor.run {
            // 중복된 사진이 포함되지 않도록 필터링합니다.
            let newUniquePhotos = newPhotos.filter { newPhoto in
                !self.photos.contains(where: { $0.id == newPhoto.id })
            }
            // 새로운 사진들을 기존 사진 배열에 추가합니다.
            self.photos.append(contentsOf: newUniquePhotos)
            
            // 사진을 날짜순으로 정렬합니다.
            self.photos.sort { $0.date ?? Date() > $1.date ?? Date() }
            
            lastFetchIndex = endIndex
            hasMorePhotos = endIndex < assets.count
            isFetching = false
        }
    }
    
    // PHAsset에서 사진의 정보를 가져오는 로직을 담당합니다.
    // 각 사진의 이미지, 위치 정보 등을 불러와 Photo 객체로 변환합니다.
    private func getPhotoInfo(for asset: PHAsset) async -> Photo? {
        // PHImageRequestOptions 설정: 고품질의 이미지를 비동기적으로 가져옵니다.
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        // 화면 크기 및 해상도에 맞게 이미지 크기를 조정합니다.
        let scale = await UIScreen.main.scale
        let screenWidth = await UIScreen.main.bounds.width
        let targetSize = CGSize(width: screenWidth * scale / 3, height: screenWidth * scale / 3)
        
        // requestImage 메서드를 사용해 PHAsset에서 이미지를 가져옵니다.
        let image = await requestImage(for: asset, targetSize: targetSize, options: options)
        
        // 위치 정보를 가져옵니다. 위치 정보가 없을 경우 nil을 반환합니다.
        let location = await getLocationString(from: asset)
        
        guard let image = image else { return nil }
        
        // CoreDataManager를 통해 즐겨찾기 상태를 확인했습니다.
        let isFavorite = CoreDataManager.shared.isFavoritePhoto(id: asset.localIdentifier)
        
        // 모든 정보를 포함한 Photo 객체를 반환합니다.
        return Photo(
            id: asset.localIdentifier,
            image: image,
            date: asset.creationDate,
            location: location,
            isFavorite: isFavorite,
            asset: asset,
            assetIdentifier: asset.localIdentifier
        )
    }
    
    // PHAsset에서 이미지를 요청해 반환하는 로직을 담당합니다.
    private func requestImage(for asset: PHAsset, targetSize: CGSize, options: PHImageRequestOptions) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    // PHAsset에서 위치 정보를 가져와 문자열로 반환합니다.
    private func getLocationString(from asset: PHAsset) async -> String? {
        guard let location = asset.location else { return nil }
        
        return await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    // 도시와 국가 정보를 가져와 문자열로 결합합니다.
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    let locationString = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
                    // 위치 정보가 유효한 경우 반환합니다.
                    continuation.resume(returning: locationString.isEmpty ? nil : locationString)
                } else {
                    // 위치 정보를 가져오는 데 실패한 경우 nil을 반환합니다.
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
