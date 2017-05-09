//
//  FirstViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 09/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit
import CoreLocation
import SlideMenuControllerSwift

class FirstViewController: UIViewController {

    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        // Do any additional setup after loading the view.
    }
    
    private func navigateToLogin() {
        let login = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginTableViewController") as! LoginTableViewController
        navigationController?.pushViewController(login, animated: false)
    }
    
    private func navigateToDashboard() {
        let dashboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateInitialViewController() as! DashboardViewController
        let leftViewController = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let slidingViewController = SlideMenuController(mainViewController: dashboard, leftMenuViewController: leftViewController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = slidingViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    fileprivate func navigateUser() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: Keys.LogIn) {
            let userID = defaults.string(forKey: Keys.UserID)
            let password = defaults.string(forKey: Keys.Password)
            getUserDetails(userID: userID, password: password)
        } else {
            navigateToLogin()
        }
    }
    
    private func getUserDetails(userID: String?, password: String?) {
        APICaller.getInstance().logIn(emailOrMobile: userID, password: password, onUserResponse: { _ in
            self.navigateToDashboard()
        }, onError: { message in
            UIApplication.topViewController()?.showHUDWithText(text: message)
        })
    }
}

extension FirstViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            navigateUser()
        }
    }
}
