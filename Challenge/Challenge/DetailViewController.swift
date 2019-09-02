//
//  DetailViewController.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var svStreet: UIStackView!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var svPostalCode: UIStackView!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblCoordinates: UILabel!
    @IBOutlet weak var svDistance: UIStackView!
    @IBOutlet weak var lblDistance: UILabel!
    
    var suggestion: Suggestion!
    var locationCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        fetchDetails()
    }
    
    private func setTitle() {
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let address = suggestion.address
        title = address.street ?? address.city ?? address.country
    }
    
    private func fetchDetails() {
        
        Services.details(locationId: suggestion.locationId, prox: locationCoordinate) { [weak self] (result, error) in
            
            if let error = error {
                self?.showError(error)
            } else if let result = result {
                self?.showDetails(result)
//                self?.showMap(detail)
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
    
    override public var traitCollection: UITraitCollection {
    
        let traitCollections: [UITraitCollection]
        if UIDevice.current.orientation.isPortrait {
            traitCollections = [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)]
        } else {
            traitCollections = [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)]
        }
        
        return UITraitCollection(traitsFrom: traitCollections)
    }
}
