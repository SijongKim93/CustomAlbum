//
//  CoreDataManager.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Favorite")
        persistentContainer.loadPersistentStores { _, error in
            if error != nil {
                self.alertMessage = "즐겨찾기 사진 저장 실패"
                self.showAlert = true
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 데이터 변경사항을 저장하는 로직을 담당합니다.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                self.alertMessage = "데이터 저장 실패: \(nserror.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    // 별을 눌러 즐겨찾기 추가 시 사진을 저장하는 로직을 담당합니다.
    func saveFavoritePhoto(id: String, image: UIImage, date: Date?, location: String?, assetIdentifier: String) {
        let entity = Favorite(context: context)
        entity.id = id
        entity.image = image.pngData()?.base64EncodedString()
        entity.date = date
        entity.location = location
        entity.isFavorite = true
        entity.assetIdentifier = assetIdentifier
        
        saveContext()
    }
    
    // 즐겨찾기 내 사진 삭제 시 해당하는 ID를 확인해 삭제하도록 구현했습니다.
    func deleteFavoritePhoto(by id: String) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            self.alertMessage = "즐겨찾기 사진 삭제 중 오류 발생: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    // 모든 즐겨찾기 된 사진을 가져와 페치하는 로직을 담당합니다.
    func fetchFavoritePhotos() -> [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            self.alertMessage = "즐겨찾기 사진 가져오기 중 오류 발생: \(error.localizedDescription)"
            self.showAlert = true
            return []
        }
    }
    
    // 특정 ID가 즐겨찾기 사진인지 확인하는 로직을 담당합니다.
    func isFavoritePhoto(id: String) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            self.alertMessage = "즐겨찾기 상태 확인 중 오류 발생: \(error.localizedDescription)"
            self.showAlert = true
            return false
        }
    }
}
