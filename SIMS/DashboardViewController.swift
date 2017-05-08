//
//  DashboardViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class DashboardViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(currentMember().name)
        //addLeftBarButtonWithImage(UIImage(named: "hamburger") ?? UIImage())
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func leftBarButtonTapped() {
       self.toggleLeft()
    }

}
