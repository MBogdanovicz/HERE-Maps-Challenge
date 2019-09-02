//
//  LocationDetail.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 01/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation

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

struct LocationDetails: Decodable {
    
    let locationId: String
    let locationType: String
    let displayPosition: Position
    let mapView: MapView
    let address: Address
    
    struct Position: Codable {
        
        let latitude: Double
        let longitude: Double
    }
    
    struct MapView: Codable {
        
        let topLeft: Position
        let bottomRight: Position
    }
}
