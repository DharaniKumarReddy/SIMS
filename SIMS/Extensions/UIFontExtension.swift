//
//  UIFontExtension.swift
//  SIMS
//
//  Created by Dharani Reddy on 16/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import UIKit

extension UIFont {
    func sizeOfString (string: NSString, constrainedToWidth width: Double) -> CGSize {
        return string.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSFontAttributeName: self],
                                   context: nil).size
    }
}
