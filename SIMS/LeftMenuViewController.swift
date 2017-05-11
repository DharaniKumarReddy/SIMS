//
//  LeftMenuViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    weak var delegate: LeftMenuProtocol?
    
    @IBOutlet private weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userLabel.text = Member.currentMember()?.name
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        closeLeft()
    }

}

protocol LeftMenuProtocol: class {
    /**
     Pass the selection when a menu item is selected
     */
    func leftMenuItemsClicked(menuTag: Int)
}
