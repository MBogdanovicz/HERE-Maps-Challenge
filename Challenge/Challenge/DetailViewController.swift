//
//  DetailViewController.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var suggestion: Suggestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDetails()
    }
    
    private func fetchDetails() {
        
        Services.details(locationId: suggestion.locationId) { (detail, error) in
            
        }
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
