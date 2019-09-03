//
//  Suggestion.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation
import CoreData

struct Suggestions: Decodable {
    
    let suggestions: [Suggestion]
}

struct Suggestion: Decodable {

    let label: String
    let language: String
    let countryCode: String
    let locationId: String
    let address: Address
    let distance: Int?
    let matchLevel: String
}

struct Address: Decodable, CoreDataEntity {
    
    let label: String?
    let country: String
    let state: String?
    let county: String?
    let city: String?
    let district: String?
    let street: String?
    let houseNumber: String?
    let unit: String?
    let postalCode: String?
    
    init(label: String? = nil, country: String, state: String? = nil, county: String? = nil, city: String? = nil,
         district: String? = nil, street: String? = nil, houseNumber: String? = nil, unit: String? = nil, postalCode: String? = nil) {
        
        self.label = label
        self.country = country
        self.state = state
        self.county = county
        self.city = city
        self.district = district
        self.street = street
        self.houseNumber = houseNumber
        self.unit = unit
        self.postalCode = postalCode
    }
    
    init?(from managedObject: NSManagedObject) {
        
        guard let country = managedObject.value(forKey: "country") as? String else {
            return nil
        }
        
        self.label = managedObject.value(forKey: "label") as? String
        self.country = country
        self.state = managedObject.value(forKey: "state") as? String
        self.county = managedObject.value(forKey: "county") as? String
        self.city = managedObject.value(forKey: "city") as? String
        self.district = managedObject.value(forKey: "district") as? String
        self.street = managedObject.value(forKey: "street") as? String
        self.houseNumber = managedObject.value(forKey: "houseNumber") as? String
        self.unit = managedObject.value(forKey: "unit") as? String
        self.postalCode = managedObject.value(forKey: "postalCode") as? String
    }
    
    func managedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let addressMO = NSManagedObject(entity: entity(in: context)!, insertInto: context)
        addressMO.setValue(label, forKey: "label")
        addressMO.setValue(country, forKey: "country")
        addressMO.setValue(state, forKey: "state")
        addressMO.setValue(county, forKey: "county")
        addressMO.setValue(city, forKey: "city")
        addressMO.setValue(district, forKey: "district")
        addressMO.setValue(street, forKey: "street")
        addressMO.setValue(houseNumber, forKey: "houseNumber")
        addressMO.setValue(unit, forKey: "unit")
        addressMO.setValue(postalCode, forKey: "postalCode")
        
        return addressMO
    }
}
