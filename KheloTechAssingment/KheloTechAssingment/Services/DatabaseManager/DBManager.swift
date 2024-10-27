//
//  DBManager.swift
//  KheloTechAssingment
//
//  Created by Abhinav on 27/10/24.
//
import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.persistentContainer = appDelegate.persistentContainer
    }

    func saveSportsList(data: [Datum], completion: @escaping (Bool) -> Void) {
        deleteAllList { [weak self] success in
            guard success else {
                completion(false)
                return
            }
            self?.persistentContainer.performBackgroundTask { context in
                self?.insertSportsData(data, into: context, completion: completion)
            }
        }
    }

    func fetchSportsList(completion: @escaping ([SportsList]?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<SportsList> = SportsList.fetchRequest()
            do {
                let sportsList = try context.fetch(fetchRequest)
                completion(sportsList)
            } catch {
                print("Failed to fetch sports list: \(error)")
                completion(nil)
            }
        }
    }
    
    func deleteSpecificUser(sport: Datum, completion: @escaping (Bool) -> Void) {
        persistentContainer.performBackgroundTask { context in
            self.deleteSport(withID: sport.nsrsSportID, in: context, completion: completion)
        }
    }
    
    private func deleteAllList(completion: @escaping (Bool) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SportsList.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                print("Successfully deleted all sports list.")
                completion(true)
            } catch {
                print("Failed to delete sports list: \(error)")
                completion(false)
            }
        }
    }
    
    private func insertSportsData(_ data: [Datum], into context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        for sport in data {
            let entity = SportsList(context: context)
            entity.sportID = Int64(sport.sportID ?? 0)
            entity.sportName = sport.sportName ?? ""
            entity.rfSportDBName = sport.rfSportDBName ?? ""
            entity.status = sport.status ?? ""
            entity.nsrsSportID = Int64(sport.nsrsSportID ?? 0)
        }
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save sports data: \(error)")
            completion(false)
        }
    }
    
    private func deleteSport(withID id: Int?, in context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        guard let id = id else {
            print("Invalid sport ID")
            completion(false)
            return
        }
        
        let fetchRequest: NSFetchRequest<SportsList> = SportsList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nsrsSportID == %d", id)
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if let recordToDelete = fetchedResults.first {
                context.delete(recordToDelete)
                try context.save()
                print("Successfully deleted specific sport.")
                completion(true)
            } else {
                print("No record to be delete.")
                completion(false)
            }
        } catch {
            print("Failed to fetch or delete sport: \(error)")
            completion(false)
        }
    }
    
    func fetchSportsListSortedByName(completion: @escaping ([SportsList]?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<SportsList> = SportsList.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sportName", ascending: true)]
            do {
                let sportsList = try context.fetch(fetchRequest)
                completion(sportsList)
            } catch {
                print("Failed error \(error)")
                completion(nil)
            }
        }
    }

    func fetchSportsListSortedByID(completion: @escaping ([SportsList]?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<SportsList> = SportsList.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sportID", ascending: true)]
            do {
                let sportsList = try context.fetch(fetchRequest)
                completion(sportsList)
            } catch {
                print("Failed ID: \(error)")
                completion(nil)
            }
        }
    }
}
