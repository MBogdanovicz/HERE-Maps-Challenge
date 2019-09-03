//
//  LocationDetail.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 01/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation
import NMAKit
import CoreData

struct Location: Decodable {
    
    let response: Response
}

struct Response: Decodable {
    
    let view: [View]
}

struct View: Decodable {
    
    let result: [Result]
}

struct Result: Decodable {
    
    let distance: Double?
    let location: LocationDetails
}

struct LocationDetails: Decodable, CoreDataEntity {
    
    let locationId: String
    let locationType: String
    let displayPosition: Position
    let mapView: MapView
    let address: Address
    var distance: Double?
    
    init(locationId: String, locationType: String, displayPosition: Position, mapView: MapView, address: Address, distance: Double? = nil) {
        
        self.locationId = locationId
        self.locationType = locationType
        self.displayPosition = displayPosition
        self.mapView = mapView
        self.address = address
        self.distance = distance
    }
    
    init?(from managedObject: NSManagedObject) {
        
        guard let locationId = managedObject.value(forKey: "locationId") as? String,
            let locationType = managedObject.value(forKey: "locationType") as? String,
            let displayPositionMO = managedObject.value(forKey: "displayPosition") as? NSManagedObject,
            let mapViewMO = managedObject.value(forKey: "mapView") as? NSManagedObject,
            let addressMO = managedObject.value(forKey: "address") as? NSManagedObject,
            let displayPosition = Position(from: displayPositionMO),
            let mapView = MapView(from: mapViewMO),
            let address = Address(from: addressMO) else {
                return nil
        }
        
        self.locationId = locationId
        self.locationType = locationType
        self.displayPosition = displayPosition
        self.mapView = mapView
        self.address = address
        self.distance = managedObject.value(forKey: "distance") as? Double
    }
    
    @discardableResult
    func managedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let locationDetailsMO = NSManagedObject(entity: entity(in: context)!, insertInto: context)
        locationDetailsMO.setValue(locationId, forKey: "locationId")
        locationDetailsMO.setValue(locationType, forKey: "locationType")
        locationDetailsMO.setValue(distance, forKey: "distance")
        locationDetailsMO.setValue(displayPosition.managedObject(in: context), forKey: "displayPosition")
        locationDetailsMO.setValue(mapView.managedObject(in: context), forKey: "mapView")
        locationDetailsMO.setValue(address.managedObject(in: context), forKey: "address")
        return locationDetailsMO
    }
}

struct Position: Decodable, CoreDataEntity {
    
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(from managedObject: NSManagedObject) {
        
        guard let latitude = managedObject.value(forKey: "latitude") as? Double,
            let longitude = managedObject.value(forKey: "longitude") as? Double else {
                return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func geoCoordinates() -> NMAGeoCoordinates {
        
        return NMAGeoCoordinates(latitude: latitude, longitude: longitude)
    }
    
    func managedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let positionMO = NSManagedObject(entity: entity(in: context)!, insertInto: context)
        positionMO.setValue(latitude, forKey: "latitude")
        positionMO.setValue(longitude, forKey: "longitude")
        
        return positionMO
    }
}

struct MapView: Decodable, CoreDataEntity {
    
    let topLeft: Position
    let bottomRight: Position
    
    init(topLeft: Position, bottomRight: Position) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
    init?(from managedObject: NSManagedObject) {
        
        guard let topLeftMO = managedObject.value(forKey: "topLeft") as? NSManagedObject,
            let bottomRightMO = managedObject.value(forKey: "bottomRight") as? NSManagedObject,
            let topLeft = Position(from: topLeftMO),
            let bottomRight = Position(from: bottomRightMO) else {
                return nil
        }
                
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
    func managedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let mapViewMO = NSManagedObject(entity: entity(in: context)!, insertInto: context)
        mapViewMO.setValue(topLeft.managedObject(in: context), forKey: "topLeft")
        mapViewMO.setValue(bottomRight.managedObject(in: context), forKey: "bottomRight")
        
        return mapViewMO
    }
}
