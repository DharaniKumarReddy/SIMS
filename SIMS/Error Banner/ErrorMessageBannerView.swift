//
//  ErrorMessageBannerView.swift
//  AlwaysOn
//
//  Created by Muralitharan on 27/04/16.
//  Copyright © 2016 Onlife Health. All rights reserved.
//

import Foundation
import UIKit


/**
 Error Message Banner View shows the error messages at the top of every view controller.
 - Title Error Message
 - Description
 */
class ErrorMessageBannerView : UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isVisible = false
    var timer: Timer!
    
    func showBanner(errorDescription: String,timeInterval:  TimeInterval) {
        isVisible = true
        descriptionLabel.text = errorDescription
        self.initiateTimer(timeInterval)
    }
    
    func initiateTimer(_ timeInterval: TimeInterval) {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(ErrorMessageBannerView.timerFires), userInfo: nil, repeats: true)
    }
    
    func timerFires() {
        if self.isVisible {
            self.dismissView()
            self.isVisible = false
        }
    }
    
    func invalidateTimer() {
        if let timer = timer {
            if timer.isValid {
                timer.invalidate() // just in case this button is tapped multiple times
            }
        }
    }
    
    @IBAction func closeButton_Tapped(_ sender: AnyObject) {
        if isVisible {
          dismissView()
          isVisible = false
        }
    }
    
    @IBAction func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.up && isVisible {
            dismissView()
            self.isVisible = false
        }
    }
    
    func dismissView() {
        var animateFrame = self.frame
        animateFrame.origin.y = -100
        UIView.animate(withDuration: 0.50, animations: {
            self.frame = animateFrame
            }, completion:{ finished in
                self.isVisible = false
                self.invalidateTimer()
                self.removeFromSuperview()
            })
    }
    
   
}
