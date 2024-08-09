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
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Favorite")
        persistentContainer.loadPersistentStores { _, error in
            if error != nil {
                fatalError("즐겨찾기 사진 저장 실패")
                // 이용자에게 알려줄 수 있도록 예외 처리
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveFavoritePhoto(id: String, image: UIImage, date: Date?, location: String?) {
        let entity = Favorite(context: context)
        entity.id = id
        entity.image = image.pngData()?.base64EncodedString()
        entity.date = date
        entity.location = location
        entity.isFavorite = true
        
        saveContext()
    }
    
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
            print("Error deleting favorite photo: \(error)")
        }
    }
    
    func fetchFavoritePhotos() -> [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorite photos: \(error)")
            return []
        }
    }
    
}
