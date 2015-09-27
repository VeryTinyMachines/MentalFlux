//
//  Fade.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/22/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: NSTimeInterval = 0.6, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)	}
    
    func fadeOut(duration: NSTimeInterval = 0.6, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}