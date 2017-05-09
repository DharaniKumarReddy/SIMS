//
//  DashboardViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import MapKit

let iPhoneSE   =   UIScreen.main.bounds.height == 568.0

class DashboardViewController: UIViewController {

    var locationManager: CLLocationManager?
    
    var matchingItems:[MKMapItem] = []
    
    var searchController: UISearchController!
    
    @IBOutlet private weak var filesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    @IBOutlet fileprivate weak var mapView: MKMapView!
    @IBOutlet fileprivate weak var tblSearchResults: UITableView!
    @IBOutlet fileprivate weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showFilesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        determineCurrentLocation()
        configureSearchController()
        //searchDisplayController?.searchResultsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    private func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Patient Pickup Location"
        searchController.searchBar.delegate = self as UISearchBarDelegate
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    @IBAction private func leftBarButtonTapped() {
       self.toggleLeft()
    }
    
    @IBAction private func showFiles(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            checkMarkImageView.image = UIImage(named: "Checked")
            alterFilesHeight(height: iPhoneSE ? 273 : 250)
        } else {
            checkMarkImageView.image = UIImage(named: "Unchecked")
            alterFilesHeight(height: 100)
        }
    }
    
    private func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager?.startUpdatingLocation()
        }
    }
    
    private func alterFilesHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            self.filesHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }
}

extension DashboardViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        locationManager?.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        
        let region = MKCoordinateRegion (center:  location,span: span)
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        showHUDWithText(text: "\(error)")
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        let place = matchingItems[indexPath.row].placemark
        cell.placeLabel.text = place.name
        
        return cell
    }
}

extension DashboardViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableViewHeightConstraint.priority = 1
        tableViewBottomConstraint.priority = 999
        view.layoutIfNeeded()
        tblSearchResults.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewHeightConstraint.priority = 999
        tableViewBottomConstraint.priority = 1
        view.layoutIfNeeded()
        tblSearchResults.reloadData()
    }
}

//extension DashboardViewController: UISearchControllerDelegate {
//    
//}
//
extension DashboardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchController.searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            //searchDisplayController?.searchResultsTableView.tableView.reloadData()
            self.tblSearchResults.reloadData()
        })
    }
}

class SearchCell: UITableViewCell {
    @IBOutlet fileprivate weak var placeLabel: UILabel!
}
