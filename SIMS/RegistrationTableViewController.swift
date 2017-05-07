//
//  RegistrationTableViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit

let Registration_Placeholers = ["Name", "Mobile No", "Email ID", "Password", "Re-Password", "Address", "City"]

class RegistrationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Registration"
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Registration_Placeholers.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case _ where indexPath.row >= Registration_Placeholers.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            cell.titleButton.setTitle(indexPath.row == 7 ? "REGISTER" : "LOGIN", for: .normal)
            cell.titleButton.tag = indexPath.row
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.placeholder = Registration_Placeholers[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.titleLabel.text = Registration_Placeholers[indexPath.row]
            if indexPath.row == 0 {
                cell.textField.becomeFirstResponder()
            }
            cell.isLogin = false
            return cell
        }
    }
    
    @IBAction private func actionButtonTapped(button: UIButton) {
        if button.tag == 7 {
            let checkOTP = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOTPTableViewController") as! CheckOTPTableViewController
            navigationController?.pushViewController(checkOTP, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
