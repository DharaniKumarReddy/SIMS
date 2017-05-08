//
//  ViewControllerExtension.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showHUDWithText(text: String) {
        var hud: MBProgressHUD! = MBProgressHUD(for: view)
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
        } else {
            hud.show(animated: true)
        }
        
        hud.bezelView.style = .solidColor
        hud.bezelView.color = RGBA(0, g: 0, b: 205, a: 0.7)
        hud.backgroundView.style = .solidColor
        hud.label.textColor = UIColor.white
        hud.contentColor = UIColor.white
        hud.label.text = text
        view.isUserInteractionEnabled = false
    }
        
    func hideHUD() {
        if let hud = MBProgressHUD(for: view) {
            hud.hide(animated: true)
        }
        view.isUserInteractionEnabled = true
    }
        
    func hideHUDWithText(text: String, completion: Void? = nil) {
        let hud = MBProgressHUD(for: view)
        hud?.mode = .text
        hud?.label.text = text
            
        if let completionBlock = completion {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                hud?.hide(animated: true)
                completionBlock
            })
        } else {
            hud?.hide(animated: true, afterDelay: 1.5)
        }
            
        view.isUserInteractionEnabled = true
    }
}
