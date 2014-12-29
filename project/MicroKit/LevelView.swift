//
//  Level.swift
//  Runes
//
//  Created by Alex Usbergo on 30/07/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit


public protocol LevelViewDelegate : NSObjectProtocol {
    
    /// Called when the user touch is over a dot
    func levelView(LevelView: AnyObject, beganTouchWithDot dot: Dot)
    
    /// Called when the user touch is over a dot
    func levelView(LevelView: AnyObject, didTouchDot dot: Dot)
    
    /// The user interaction is over
    func levelViewTouchesEnded(LevelView: AnyObject)
    
    /// The time is up or the player reached the end dot
    func levelView(LevelView: AnyObject, levelOverWithSuccess success: Bool)
}

@IBDesignable public class LevelView : UIView {
    
    /// The level delegate
    public var delegate: LevelViewDelegate?
    
    /// The level time
    @IBInspectable public var time: Int = 30;
    public weak var timeLabel: TimeLabel?

    // flags
    public var beganTouches: Bool = false
    public var abortSelection: Bool = false
    public var endDotSelected: Bool = false {
        didSet {
            if (endDotSelected) {
                self.levelOver()
            }
        }
    }
    
    // private
    var timer: NSTimer?
    
    //PRAGMA MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    //PRAGMA MARK: Touches
    
    /// Tells the receiver when one or more fingers touch down in a view or window.
    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
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
    override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
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
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if !self.beganTouches || self.abortSelection {
            return
        }
        
        self.delegate?.levelViewTouchesEnded(self)
    }
    
    //PRAGMA MARK: Timer
    
    func tick() {
        
        if self.time > 0 {
            self.time--
            self.timeLabel?.time = self.time
        }
        
        // time's up!
        if self.time == 1 {
            self.levelOver()
        }
    }
    
    
    //PRAGMA MARK: Level over
    
    func levelOver() {
        
        //stops the timer
        self.timer?.invalidate()
        
        //notifies the delegate
        let success = self.endDotSelected
        self.delegate?.levelView(self, levelOverWithSuccess: success)
    }

}
