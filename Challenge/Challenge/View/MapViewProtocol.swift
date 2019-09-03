//
//  MapViewProtocol.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import NMAKit

protocol MapViewProtocol: class {
    
    var currentMarker: NMAMapMarker? { get set }
}

extension MapViewProtocol {
    
    func showPosition(_ position: Position, boundingBox: MapView, mapView: NMAMapView) {
        
        let boundingBox = NMAGeoBoundingBox(topLeft: boundingBox.topLeft.geoCoordinates(), bottomRight: boundingBox.bottomRight.geoCoordinates())
        mapView.copyrightLogoPosition = .bottomRight
        mapView.set(boundingBox: boundingBox, animation: .linear)
        
        addMarker(in: position, mapView: mapView)
    }
    
    func addMarker(in position: Position, mapView: NMAMapView) {
        
        if let currentMarker = currentMarker {
            mapView.remove(currentMarker)
        }
        
        let marker = NMAMapMarker(geoCoordinates: position.geoCoordinates(), image: UIImage(named: "location"))
        mapView.add(marker)
        currentMarker = marker
    }
}
