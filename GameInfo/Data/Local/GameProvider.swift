//
//  GameProvider.swift
//  GameInfo
//
//  Created by Djaka Permana on 12/06/23.
//

import Foundation
import CoreData

class GameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GamesInfoDB")
            
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
            
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavorite(completion: @escaping(_ games: [GameModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameModel] = []
                for result in results {
                    
                    let parentPlatformsJson = result.value(forKey: "parentPlatforms") as? String
                    guard let dataFromJsonString = parentPlatformsJson?.data(using: .utf8) else {
                        return
                    }
                    let parentPlatoforms = try JSONDecoder().decode([ParentPlatform].self, from: dataFromJsonString)
                    
                    let game = GameModel(
                        id: result.value(forKeyPath: "id") as? Int,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        parentPlatforms: parentPlatoforms
                    )
                    
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getFavorite(_ id: Int, completion: @escaping(_ game: GameModel?) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    
                    let parentPlatformsJson = result.value(forKey: "parentPlatforms") as? String
                    guard let dataFromJsonString = parentPlatformsJson?.data(using: .utf8) else {
                        return
                    }
                    let parentPlatoforms = try JSONDecoder().decode([ParentPlatform].self, from: dataFromJsonString)
                    
                    let game = GameModel(
                        id: result.value(forKeyPath: "id") as? Int,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        parentPlatforms: parentPlatoforms
                    )
     
                    completion(game)
                } else {
                    completion(nil)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createFavorite(
        _ id: Int,
        _ name: String,
        _ released: String,
        _ backgroundImage: String,
        _ rating: Double,
        _ parentPlatforms: [ParentPlatform],
        completion: @escaping() -> Void
    ) {
        
        let encodedData = try? JSONEncoder().encode(parentPlatforms)
        let jsonParentPlatforms = String(data: encodedData ?? Data(), encoding: .utf8)
        
        let taskContext = newTaskContext()
        taskContext.perform {
            
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: taskContext) {
                
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                game.setValue(name, forKeyPath: "name")
                game.setValue(released, forKeyPath: "released")
                game.setValue(backgroundImage, forKeyPath: "backgroundImage")
                game.setValue(rating, forKeyPath: "rating")
                game.setValue(jsonParentPlatforms, forKeyPath: "parentPlatforms")

                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
