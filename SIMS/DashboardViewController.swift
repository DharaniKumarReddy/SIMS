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

    @IBOutlet private weak var filesHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        
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
    
    private func alterFilesHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            self.filesHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }

}
