//
//  CoreDataUtility.swift
//  Assignment
//
//  Created by Devin Ellis  on 1/12/23.
//

import Foundation
import CoreData

class MovieCoreDataUtility : AppDelegate{
    
    
    var context: NSManagedObjectContext?
    
    lazy var applicationDocumentsDirectory: URL = {
       let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
       let modelURL = Bundle.main.url(forResource: "MovieCoreData", withExtension: "momd")!
       return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "MovieCoreData")
       container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
       if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
       }
       })
       return container
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
       // Create the coordinator and store
       let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
       let url = applicationDocumentsDirectory.appendingPathComponent("MovieCoreData.sqlite")
       var failureReason = "There was an error creating or loading the application’s saved data."
       let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true as Bool), NSInferMappingModelAutomaticallyOption: NSNumber(value: true as Bool)]
       do {
          try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
       } catch {
          // Report any error we got.
          var dict = [String: AnyObject]()
          dict[NSLocalizedDescriptionKey] = "Failed to initialize the application’s saved data" as AnyObject
          dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
          dict[NSUnderlyingErrorKey] = error as NSError
          NSLog("\(dict)")
          abort()
       }
       return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
       let coordinator = persistentStoreCoordinator
       var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
       managedObjectContext.persistentStoreCoordinator = coordinator
       return managedObjectContext
    }()
    
    func getContext() {
       if #available(iOS 10.0, *) {
          self.context = self.persistentContainer.viewContext
       } else {
          self.context = self.managedObjectContext
       }
    }
    
    func saveFavoriteMovie(movieObj:MovieDetail?)->Bool{
        self.getContext()
        let model = NSEntityDescription.insertNewObject(forEntityName: "MovieDetailCoreData", into: self.context!) as! MovieDetailCoreData
        guard let movieObj = movieObj else {
            return false
        }
        model.id =  Int16(truncatingIfNeeded: movieObj.id!) //as! Int16
        model.posterPath =  movieObj.posterPath
        model.releaseDate =  movieObj.releaseDate
        model.adult =  movieObj.adult ?? false
        model.backdropPath =  movieObj.backdropPath
        model.originalLanguage =  movieObj.originalLanguage
        model.overview = movieObj.overview
        model.popularity =  movieObj.popularity ?? 0
        model.title =  movieObj.title
        model.video =  movieObj.video ?? false
        model.voteAverage =  movieObj.voteAverage ?? 0.0
        model.voteCount =  Int16(truncatingIfNeeded: movieObj.voteCount! ) //x?? Int16(0.0)
        model.originalTitle =  movieObj.originalTitle
        
        do {
              try self.context?.save()
              print("Model Saved : \(model)")
            return true
        } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    func fetchAllFavoriteMovies() -> [MovieDetailCoreData] {
        self.getContext()
        let managedContext = self.context!
        
        let fetchMovies = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailCoreData")
        var mvList = [MovieDetailCoreData]()
        do {
            let result = try managedContext.fetch(fetchMovies)
//            for i in result {
//                mvList.append(mapCoreDataToModel(model: i as! MovieDetailCoreData)!)
//            }
            mvList = result as! [MovieDetailCoreData]
        }catch let error as NSError {
            print("Couldn't save user Data \(error) , \(error.userInfo)")
        }
        return mvList
    }
    func mapCoreDataToModel(model : MovieDetailCoreData) -> MovieDetail?{
        
        var md : MovieDetail?
        
        md?.id = Int(model.id)
        md?.posterPath = model.posterPath
        md?.releaseDate = model.releaseDate
        md?.adult = model.adult
        md?.backdropPath = model.backdropPath
        md?.originalLanguage = model.originalLanguage
        md?.overview = model.overview
        md?.popularity = model.popularity
        md?.title = model.title
        md?.video = model.video
        md?.voteAverage = model.voteAverage
        md?.voteCount = Int(model.voteCount)
        md?.originalTitle = model.originalTitle
        
        return md
    }
    
}
