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

extension UIViewController {
    
    fileprivate var keyWindow: UIWindow {
        if let _ = UIApplication.shared.keyWindow {
            return UIApplication.shared.keyWindow!
        } else {
            return UIApplication.shared.delegate!.window!!
        }
    }
    
    fileprivate struct ErrorBanner {
        static var errorBanner: ErrorMessageBannerView?
    }
    
    fileprivate var bannerView: ErrorMessageBannerView {
        get {
            if let banner = ErrorBanner.errorBanner {
                return banner
            }
            ErrorBanner.errorBanner = Bundle.main.loadNibNamed("ErrorMessageBannerView", owner: self, options: nil)?.first as? ErrorMessageBannerView!
            return ErrorBanner.errorBanner!
        }
        set {
            ErrorBanner.errorBanner = Bundle.main.loadNibNamed("ErrorMessageBannerView", owner: self, options: nil)?.first as? ErrorMessageBannerView!
        }
    }
    
    func showErrorBanner(message: String, backgroundColor: UIColor?=nil, timeInterval:  TimeInterval = 10) {
        if message == "" || message == "cancelled" || message == "cancelado" {
            return
        }
        
        if let color = backgroundColor {
            bannerView.backgroundColor = color
        } else {
            bannerView.backgroundColor = RGBA(140, g: 29, b: 64)
        }
        let messageDescription  = NSLocalizedString(message, comment: "")
        let messageDescriptionHeight = contentHeight(fontName:"Helvetica Neue", fontSize: 16.0, screenWidth: (UIScreen.main.bounds.width - 50 ), text: messageDescription)
        
        bannerView.frame = CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: messageDescriptionHeight + CGFloat(45))
        bannerView.showBanner(errorDescription: message, timeInterval: timeInterval)
        keyWindow.addSubview(bannerView)
        
        var animateFrame = bannerView.frame
        animateFrame.origin.y = 0
        
        UIView.animate(withDuration: 0.50, animations: {
            self.bannerView.frame = animateFrame
        }, completion:nil
        )
    }
    
    func hideErrorBanner() {
        if bannerView.isVisible {
            bannerView.dismissView()
        }
    }
}
