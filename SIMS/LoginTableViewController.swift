//
//  LoginTableViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import MBProgressHUD

let Login_Placeholders = ["Email / Mobile No" , "Password"]

class LoginTableViewController: UITableViewController {
    
    var idTextField: UITextField?
    var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.placeholder = Login_Placeholders[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.titleLabel.text = Login_Placeholders[indexPath.row]
            if indexPath.row == 0 {
                cell.textField.becomeFirstResponder()
                idTextField = cell.textField
            } else {
                passwordTextField = cell.textField
                cell.textField.isSecureTextEntry = true
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as! RegisterCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            cell.titleButton.setTitle(indexPath.row == 2 ? "LOGIN" : "VERIFY YOUR ACCOUNT", for: .normal)
            cell.titleButton.tag = indexPath.row
            return cell
        }
    }
    
    @IBAction private func actionButtonTapped(button: UIButton) {
        if button.tag == 2 {
            showHUDWithText(text: "Please wait")
            APICaller.getInstance().logIn(
                emailOrMobile: idTextField?.text,
                password: passwordTextField?.text,
                onUserResponse: { member in
                    self.logIn(userID: self.idTextField?.text, password: self.passwordTextField?.text)
            }, onError: { message in
                self.hideHUDWithText(text: message)
            })
        } else {
            
        }
    }
    
    private func logIn(userID: String?, password: String?) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Keys.LogIn)
        defaults.set(userID ?? "", forKey: Keys.UserID)
        defaults.set(password ?? "", forKey: Keys.Password)
        let dashboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateInitialViewController() as! DashboardViewController
        let leftViewController = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let slidingViewController = SlideMenuController(mainViewController: dashboard, leftMenuViewController: leftViewController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = slidingViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}

class TextFieldCell: UITableViewCell {
    var isLogin = true
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        animateLabel(constraint: 30, leading: textField.tag == 0 && isLogin ? 6 : textField.tag == 4 && !isLogin ? 10 : (textField.tag == 0 || textField.tag == 6) && !isLogin ? 20 : textField.tag == 99 ? 0 : 15)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" && textField.tag != 99 {
            textField.placeholder = isLogin ? Login_Placeholders[textField.tag] : Registration_Placeholers[textField.tag]
        }
        animateLabel(constraint: 7, leading: 24)
        return true
    }
    
    private func animateLabel(constraint: CGFloat, leading: CGFloat) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabelBottomConstraint.constant = constraint
            self.titleLabelLeadingConstraint.constant = leading
            self.lineView.backgroundColor = constraint == 7 ? RGBA(64, g: 64, b: 64, a: 0.4) : RGBA(232, g: 84, b: 35)
            self.titleLabel.transform = self.titleLabel.transform.scaledBy(x: constraint == 7 ? 17/12 : 12/17, y: constraint == 7 ? 16/13 : 13/16)
            self.titleLabel.alpha = constraint == 7 ? 0 : 1.0
            self.layoutIfNeeded()
        })
    }
}

class ButtonCell: UITableViewCell {
    @IBOutlet weak var titleButton: UIButton!
}

class RegisterCell: UITableViewCell {
    
}

func RGBA(_ r: Int, g: Int, b: Int, a: CGFloat? = 1.0) -> UIColor {
    return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a!)
}

func contentHeight(fontName:String, fontSize: CGFloat, screenWidth: CGFloat, text: String) -> CGFloat {
    let font = UIFont.init(name: fontName, size: fontSize)
    let height = font?.sizeOfString(string: text as NSString, constrainedToWidth: Double(screenWidth)).height ?? 50
    return height
}
