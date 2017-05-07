//
//  CheckOTPViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit

class CheckOTPTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.placeholder = "Enter your OTP Number"
            cell.textField.tag = 99
            cell.titleLabel.text = "Enter your OTP Number"
            if indexPath.row == 0 {
                cell.textField.becomeFirstResponder()
            }
            cell.isLogin = false
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            cell.titleButton.setTitle(indexPath.row == 1 ? "VALIDATE" : "RESEND OTP", for: .normal)
            cell.titleButton.tag = indexPath.row
            return cell
        }
    }
    
    @IBAction private func actionButtonTapped(button: UIButton) {
        if button.tag == 1 {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
