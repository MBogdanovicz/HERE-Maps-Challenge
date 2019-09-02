//
//  HomeTableViewController.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit
import CoreLocation

class HomeTableViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    var locationCoordinate: CLLocationCoordinate2D?
    var suggestions: [Suggestion]?
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocation()
        configureSearchController()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = suggestions![indexPath.row].label
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = suggestions![indexPath.row]
        performSegue(withIdentifier: "DetailsSegue", sender: suggestion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let suggestion = sender as? Suggestion, let controller = segue.destination as? DetailViewController {
            controller.suggestion = suggestion
            controller.locationCoordinate = locationCoordinate
        }
    }
}

extension HomeTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            suggestions?.removeAll(keepingCapacity: false)
            tableView.reloadData()
            return
        }
        
        Services.suggestions(query: query, prox: locationCoordinate) { [weak self] (suggestions, error) in
            
            if let error = error {
                self?.showError(error)
            } else if let suggestions = suggestions {
                self?.suggestions?.removeAll(keepingCapacity: false)
                self?.suggestions = suggestions.suggestions
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureSearchController() {
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        definesPresentationContext = true
        
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension HomeTableViewController: CLLocationManagerDelegate {
    
    private func configureLocation() {
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        locationCoordinate = locValue
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
