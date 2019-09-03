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
    var sortByDistance = true
    var locationCoordinate: CLLocationCoordinate2D?
    var suggestions: [Suggestion]?
    var resultSearchController = UISearchController()
    var hasFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "Home"
        
        configureLocation()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFavorites()
        tableView.reloadData()
    }
    
    private func loadFavorites() {
        hasFavorites = !Favorite.loadFavoriteLocations().isEmpty
    }
    
    private func sortSuggestions() {
        guard let suggestions = suggestions else {
            return
        }
        
        if sortByDistance {
            self.suggestions = suggestions.sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
        } else {
            self.suggestions = suggestions.sorted(by: { $0.label < $1.label })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return hasFavorites ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return suggestions?.count ?? 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoToFavoritesCell", for: indexPath)
            cell.accessibilityIdentifier = "FavoriteCell"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = suggestions![indexPath.row].label
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let suggestion = suggestions![indexPath.row]
            performSegue(withIdentifier: "DetailsSegue", sender: suggestion)
        } else {
            sortByDistance = indexPath.row == 1
            self.sortSuggestions()
            presentedViewController?.dismiss(animated: true, completion: {
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let suggestion = sender as? Suggestion, let controller = segue.destination as? DetailViewController {
            controller.suggestion = suggestion
            controller.locationCoordinate = locationCoordinate
        } else if segue.identifier == "sortSegue" {
            resultSearchController.isActive = false
            
            let popoverViewController = segue.destination as! UITableViewController
            popoverViewController.tableView.delegate = self
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
}

extension HomeTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        
        Services.suggestions(query: query, prox: locationCoordinate) { [weak self] (suggestions, error) in
            
            if let error = error {
                self?.showError(error)
            } else if let suggestions = suggestions {
                self?.suggestions?.removeAll(keepingCapacity: false)
                self?.suggestions = suggestions.suggestions
                self?.sortSuggestions()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureSearchController() {
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
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

extension HomeTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
