//
//  UIApplicationExtension.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = baseViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let presented = baseViewController?.presentedViewController {
            return topViewController(presented)
        }
        return baseViewController
    }
}
