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
    
    private var textFields: [UITextField] = []

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
            textFields.append(cell.textField)
            cell.isLogin = false
            switch indexPath.row {
            case 1:
                cell.textField.keyboardType = .numberPad
            case 2:
                cell.textField.keyboardType = .emailAddress
            case 3, 4:
                cell.textField.isSecureTextEntry = true
            default:
                break
            }
            return cell
        }
    }
    
    @IBAction private func actionButtonTapped(button: UIButton) {
        if button.tag == 7 {
            checkRegistrationFields()
//            let checkOTP = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOTPTableViewController") as! CheckOTPTableViewController
//            navigationController?.pushViewController(checkOTP, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:- Private Methods
    
    private func checkRegistrationFields() {
        for textField in textFields {
            if textField.text == "" {
                showErrorBanner(message: Registration_Placeholers[textField.tag] + " is required")
                return
            }
        }
        let passwordTextField = textFields.filter({ $0.tag == 3 }).first
        let rePasswordTextField = textFields.filter({ $0.tag == 4 }).first
        if passwordTextField?.text != rePasswordTextField?.text {
            showErrorBanner(message: "Password and Confirm Password doesn't match")
            return
        }
    }
}
