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

class DashboardViewController: UIViewController {

    var locationManager: CLLocationManager?
    
    @IBOutlet private weak var filesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        determineCurrentLocation()
        //searchDisplayController?.searchResultsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func leftBarButtonTapped() {
       self.toggleLeft()
    }
    
    @IBAction private func showFiles(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            checkMarkImageView.image = UIImage(named: "Checked")
            alterFilesHeight(height: 250)
        } else {
            checkMarkImageView.image = UIImage(named: "Unchecked")
            alterFilesHeight(height: 150)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

extension DashboardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
