//
//  Background.swift
//  Runes
//
//  Created by Alex Usbergo on 29/12/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import Foundation

public class BackgroundView : UIView {
    
    var displayLink: CADisplayLink?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        var updater = CADisplayLink(target: self, selector: Selector("update"))
        updater.frameInterval = 1
        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.displayLink = updater;
    }
    
    public override func drawRect(rect: CGRect) {
    
        var ctx = UIGraphicsGetCurrentContext()
        
        let sliceSize = 4
        for (var i = 0; i < Int(self.bounds.size.width); i += sliceSize ) {
        
            let diceRoll = Int(arc4random_uniform(50))

            if diceRoll == 1 {
             
                let percent =  Float(arc4random()) /  Float(UInt32.max)
                let color = ColorSwatch.LightBlue.__conversion().lighterColorWithPercent(CGFloat(percent))
                
                CGContextSetFillColorWithColor(ctx, color.CGColor)
                CGContextFillRect(ctx, CGRectMake(CGFloat(i), 0, CGFloat(sliceSize), self.bounds.size.height))
            }
            

        }
    }
    
    func update() {
        
        self.setNeedsDisplay()
    }
}

