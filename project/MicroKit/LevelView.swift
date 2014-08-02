//
//  Level.swift
//  Runes
//
//  Created by Alex Usbergo on 30/07/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit


protocol LevelViewDelegate : NSObjectProtocol {
    
    /// Called when the user touch is over a dot
    func levelView(LevelView: AnyObject, beganTouchWithDot dot: Dot)
    
    /// Called when the user touch is over a dot
    func levelView(LevelView: AnyObject, didTouchDot dot: Dot)
    
    /// The user interaction is over
    func levelViewTouchesEnded(LevelView: AnyObject)
}

class LevelView : UIView {
    
    /// The level delegate
    var delegate: LevelViewDelegate?
    var beganTouches: Bool = false
    var abortSelection: Bool = false
    
    /// Tells the receiver when one or more fingers touch down in a view or window.
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        self.abortSelection = false
        
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        let view = self.hitTest(point, withEvent: nil)
        
        if view is Dot {
            self.beganTouches = true
            self.delegate?.levelView(self, beganTouchWithDot: (view as Dot))

        } else {
            self.beganTouches = false
        }
    }
    
    /// Tells the receiver when one or more fingers associated with an event move within a view or window.
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        if !self.beganTouches || self.abortSelection {
            return
        }
        
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        let view = self.hitTest(point, withEvent: nil)
        
        if view is Dot {
            let dot = view as Dot

            if !dot.selectedDot {
                self.delegate?.levelView(self, didTouchDot: dot)
            }
        }
    }
    
    /// Tells the receiver when one or more fingers are raised from a view or window.
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        
        if !self.beganTouches || self.abortSelection {
            return
        }
        
        self.delegate?.levelViewTouchesEnded(self)
    }
    
}
