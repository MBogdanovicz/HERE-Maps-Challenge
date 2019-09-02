//
//  Favorite.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit
import CoreData

class Favorite {
    
    static func loadFavoriteLocations() -> [LocationDetails] {
        let context = getContext()
        let fetchRequest = LocationDetails.fetchRequest()
        var favoriteLocations = [LocationDetails]()

        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {

                if let locationDetails = LocationDetails(from: data) {
                    favoriteLocations.append(locationDetails)
                }
            }
        } catch {
            print("Failed")
        }

        return favoriteLocations
    }
    
    static func addToFavorite(_ locationDetails: LocationDetails) {
        
        let context = getContext()
        locationDetails.managedObject(in: context)
        
        saveContext()
    }
    
    static func removeFromFavorite(_ locationDetails: LocationDetails) {

        let context = getContext()
        let fetchRequest = LocationDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "locationId = %@", locationDetails.locationId)
        
        let result = try! context.fetch(fetchRequest)

        for data in result as! [NSManagedObject] {
            context.delete(data)
        }

        saveContext()
    }
    
    static func isFavorite(_ locationId: String) -> Bool {
        
        let context = getContext()
        let fetchRequest = LocationDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "locationId = %@", locationId)
        
        if let result = try? context.fetch(fetchRequest), result.count > 0 {
            return true
        }
        
        return false
    }
//
//    static func reset() {
//
//        let context = getContext()
//        let fetchRequest = getFetchRequest()
//        let result = try! context.fetch(fetchRequest)
//
//        for data in result as! [NSManagedObject] {
//            context.delete(data)
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed saving")
//        }
//    }
    
    private static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private static func saveContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}
