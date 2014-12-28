//
//  Dot.swift
//  Runes
//
//  Created by Alex Usbergo on 29/07/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable public class Dot : UIView {
    
    //inspectable properties
    @IBInspectable var glyphEncoding: NSInteger = 0 {
        didSet {
             self.glyph = Glyph.fromInteger(glyphEncoding).__conversion()
        }
    }

    @IBInspectable var colorEncoding: NSInteger = 0 {
        didSet {
            self.color = ColorSwatch.fromInteger(colorEncoding)
        }
    }
    
    @IBInspectable var currentDotEncoding: NSInteger = 0 {
        didSet {
            self.currentDot = currentDotEncoding > 0 ? true : false
        }
    }
    
    //properties
    public var glyph: String = Glyph.random().__conversion() {
        didSet {
            self.layoutSubviews()
        }
    }

    public var color: ColorSwatch = ColorSwatch.random() {
        didSet {
            self.layoutSubviews()
        }
    }
    
    /// true if the dot is currently selected
    public var selectedDot: Bool = false
    
    /// true if it's the player dot, false otherwise
    public var currentDot: Bool = false {
        didSet {
            self.layoutSubviews()
        }
    }
    
    /// wheter a dot is matched or not (takes care of its visual treatment)
    public var matched: Bool = false {
        didSet {
            self.color = ColorSwatch.LightGreen
            self.pop()
        }
    }
    
    //subviews
    public var cirleLayer: CALayer?
    public var selectionLayer: CALayer?
    public var iconLabel: UILabel?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
    
        if !(self.cirleLayer != nil) {
            
            //initialize the cirlce layer inside of it
            self.cirleLayer = CALayer()
            self.cirleLayer!.frame = CGRectInset(self.bounds, 0, 0)
            self.cirleLayer!.cornerRadius = CGRectGetHeight(self.cirleLayer!.bounds)/2
            self.cirleLayer!.backgroundColor = ColorSwatch.Black.color(alpha: 0.1).CGColor
            self.layer.addSublayer(self.cirleLayer)
        }
        
        if !(self.selectionLayer != nil) {
                        
            //initialize the cirlce layer inside of it
            self.selectionLayer = CALayer()
            self.selectionLayer!.frame = CGRectInset(self.bounds, 0, 0)
            self.selectionLayer!.cornerRadius = CGRectGetHeight(self.selectionLayer!.bounds)/2
            self.selectionLayer!.backgroundColor = UIColor.clearColor().CGColor
            self.selectionLayer!.borderWidth = 1
            self.selectionLayer!.borderColor = ColorSwatch.White.color().CGColor
            self.layer.addSublayer(self.selectionLayer)
        }
        
        if !(self.iconLabel != nil) {
            
            self.iconLabel = UILabel(frame:  CGRectInset(self.bounds, 12, 12))
            self.iconLabel!.backgroundColor = UIColor.clearColor()
            self.iconLabel!.textColor = ColorSwatch.Black.__conversion()
            self.iconLabel!.font = UIFont(name: TypographyTrait.Glyph.rawValue, size: CGRectGetHeight(self.iconLabel!.bounds))
            self.iconLabel!.textAlignment = NSTextAlignment.Center
            self.addSubview(self.iconLabel!)
        }
        
        //configuration
        self.selectionLayer!.opacity = self.currentDot ? 1 : 0
        self.iconLabel!.text = self.glyph;
        self.iconLabel!.textColor = self.color.color()
        
        self.selectDot(self.selectedDot)
    }
    
    /// Enable or disable the circoular marker around the dot
    public func selectDot(select: Bool) {
        
        if select {
            self.cirleLayer!.backgroundColor = self.color.color(alpha: 0.8).CGColor
            self.selectedDot = true
            
        } else {
            self.cirleLayer!.backgroundColor = ColorSwatch.Black.color(alpha: 0).CGColor
            self.selectedDot = false
        }
    }
    
    /// Returns true if two dots are adjacent in the matrix, false otherwise
    public func isAdjacent(dot: Dot) -> Bool {
        
        let thisX = self.tag/10
        let thisY = self.tag - (thisX*10)
        
        let otherX = dot.tag/10
        let otherY = dot.tag - (otherX*10)
        
        let (x, y) = (abs(thisX-otherX), abs(thisY-otherY))
        
        if x <= 1 && y <= 1 && !(x == 1 && y == 1) {
            return true
            
        } else {
            return false
        }
    }
    
    /// starts spinning the dot
    public func pop(duration: NSTimeInterval = 2) {
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: nil, animations: {
            self.transform = CGAffineTransformIdentity
            self.alpha = 0.7
        }, completion: {
            (value: Bool) in
            
        })
        
    }
    
    /// Creates a line between the two dots
    public func createLineLayerToDot(dot: Dot, lineWidth: CGFloat = 32) -> CALayer {
        
        let a = self.center
        let b = dot.center
        
        let center = CGPointMake(0.5 * (a.x + b.x), 0.5 * (a.y + b.y))
        
        let value = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)
        let lenght = sqrt(value)
        let angle = atan2(a.y - b.y, a.x - b.x)
        
        let layer = CALayer()
        layer.position = center
        layer.bounds = CGRectMake(0, 0, lenght + lineWidth, lineWidth)
        layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.backgroundColor = ColorSwatch.LightGreen.color(alpha: 0.1).CGColor
        layer.cornerRadius = CGRectGetHeight(layer.bounds)/2
        
        return layer;
    }
    
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView?
    {
        print(point)
        return super.hitTest(point, withEvent: event)
    }
    

    
}

