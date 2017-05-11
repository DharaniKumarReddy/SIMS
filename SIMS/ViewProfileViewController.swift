//
//  ViewProfileViewController.swift
//  SIMS
//
//  Created by Dharani Reddy on 11/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit

class ViewProfileViewController: UIViewController {

    var member: Member?
    
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet fileprivate weak var profileImageHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        member = currentMember()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func leftBarButton_Tapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension ViewProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        
        if offsetY <= 100 && offsetY > 5 {
            UIView.animate(withDuration: 0.2, animations: {
                self.profileImageHeightConstraint.constant = 160 - offsetY
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension ViewProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewProfileCell") as! ViewProfileCell
        cell.cellLabel.text = member?.name
        return cell
    }
}

class ViewProfileCell: UITableViewCell {
    @IBOutlet fileprivate weak var cellImage: UIImageView!
    @IBOutlet fileprivate weak var cellLabel: UILabel!
}
