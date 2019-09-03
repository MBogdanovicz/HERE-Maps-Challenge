//
//  FavoritesViewController.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit
import NMAKit

class FavoritesViewController: UIViewController, MapViewProtocol {
    
    @IBOutlet weak var mapView: NMAMapView!
    @IBOutlet weak var tableView: UITableView!
    
    private var favoriteLocations: [LocationDetails]!
    var currentMarker: NMAMapMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "Favorites"
        
        loadFavorites()
    }
    
    private func loadFavorites() {
        
        favoriteLocations = Favorite.loadFavoriteLocations()
        tableView.reloadData()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = favoriteLocations[indexPath.row].address.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = favoriteLocations[indexPath.row]
        
        showPosition(location.displayPosition, boundingBox: location.mapView, mapView: mapView)
    }
}
