//
//  DetailViewController.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit
import CoreLocation
import NMAKit

class DetailViewController: UIViewController, MapViewProtocol {

    @IBOutlet weak var mapView: NMAMapView!
    @IBOutlet weak var svStreet: UIStackView!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var svPostalCode: UIStackView!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblCoordinates: UILabel!
    @IBOutlet weak var svDistance: UIStackView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var barBtnFavorite: UIBarButtonItem!
    
    private var locationDetails: LocationDetails?
    var suggestion: Suggestion!
    var locationCoordinate: CLLocationCoordinate2D?
    var currentMarker: NMAMapMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        checkFavorite()
        fetchDetails()
    }
    
    private func setTitle() {
        
        let address = suggestion.address
        title = address.street ?? address.city ?? address.country
    }
    
    private func checkFavorite() {
        
        if Favorite.isFavorite(suggestion.locationId) {
            btnFavorite.isSelected = true
            setBarBtnFavoriteImage(isFavorite: true)
        }
    }
    
    private func fetchDetails() {
        
        Services.details(locationId: suggestion.locationId, prox: locationCoordinate) { [weak self] (result, error) in
            
            if let error = error {
                self?.showError(error)
            } else if let result = result {
                self?.locationDetails = result.location
                self?.locationDetails?.distance = result.distance
                self?.showPosition(result.location.displayPosition, boundingBox: result.location.mapView, mapView: self!.mapView)
                self?.showDetails(result)
            }
        }
    }
    
    private func showDetails(_ result: Result) {
        
        let address = result.location.address
        
        if let street = address.street {
            lblStreet.text = street
        } else {
            svStreet.isHidden = true
        }
        
        if let postalCode = address.postalCode {
            lblPostalCode.text = postalCode
        } else {
            svPostalCode.isHidden = true
        }
        
        let position = result.location.displayPosition
        lblCoordinates.text = "\(position.latitude), \(position.longitude)"
        
        
        if let distance = result.distance {
            lblDistance.text = formatDistance(distance)
        } else {
            svDistance.isHidden = true
        }
    }
    
    func formatDistance(_ distance: Double) -> String {
        
        let distKm = distance / 1000
        
        if distKm > 1 {
            let rounded = (distKm * 100).rounded() / 100
            return "\(rounded) km"
        }
        
        return "\(distance) m"
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        
        if let locationDetails = locationDetails {
            if !btnFavorite.isSelected {
                Favorite.addToFavorite(locationDetails)
            } else {
                Favorite.removeFromFavorite(locationDetails)
            }
            
            btnFavorite.isSelected = !btnFavorite.isSelected
            setBarBtnFavoriteImage(isFavorite: btnFavorite.isSelected)
        }
    }
    
    private func setBarBtnFavoriteImage(isFavorite: Bool) {
        
        barBtnFavorite.image = isFavorite ? UIImage(named: "favorite-on") : UIImage(named: "favorite-off")
    }
    
    override public var traitCollection: UITraitCollection {
    
        let traitCollections: [UITraitCollection]
        if view.bounds.width < view.bounds.height {
            traitCollections = [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)]
        } else {
            traitCollections = [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)]
        }
        
        return UITraitCollection(traitsFrom: traitCollections)
    }
}
