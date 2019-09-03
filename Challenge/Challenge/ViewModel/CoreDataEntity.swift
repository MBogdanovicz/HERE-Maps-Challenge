//
//  CoreDataEntity.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataEntity {
    
    init?(from managedObject: NSManagedObject)
    func managedObject(in context: NSManagedObjectContext) -> NSManagedObject
}

extension CoreDataEntity {
    
    static func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Self.self))
    }
    
    func entity(in context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context)
    }
}
