//
//  Extensions.swift
//  TunnelbanaKit-Catalog
//
//  Created by Alex Usbergo on 08/06/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit

extension String {
    
    subscript (r: Range<Int>) -> String {
        get {
            return self.substringWithRange(Range(start: advance(self.startIndex, r.startIndex),end: advance(self.startIndex, r.endIndex)))
        }
    }
    
    subscript (index: Int) -> String? {
        get {
            if (countElements(self) < index) {
                return nil
            } else {
                return self[index..<index+1]
            }
        }
    }
}

extension UIColor {
    
    /// Parse a color string represented as #rrggbb or #rrggbb,aa
    class func colorWithHexString(hex: String) -> UIColor? {
        
        assert(hex.hasPrefix("#"), "Incorrect hex string")
        
        let color = hex[1..<6]
        let alpha = countElements(hex) > 7 && hex[7] == "," ? hex[8..<countElements(hex)].toInt() : "100".toInt()
        
        var c: CUnsignedInt = 0
        let scanner = NSScanner(string: color)
        scanner.scanHexInt(&c)
        
        return self.colorWithRGB888(c, alpha: CGFloat(alpha!)/100.0)
    }
    
    /// Returns the color with the components taken from the hex representation
    class func colorWithRGB888(rgb888: UInt32, alpha: CGFloat = 1) -> UIColor {
        
        let r = CGFloat((rgb888&0xff0000) >> 16)/255.0
        let g = CGFloat((rgb888&0xff00) >> 8)/255.0
        let b = CGFloat(rgb888&0xff)/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}


public class ImageView: UIImageView {
    
    /// Add a nice horizontal motion effect to the view
    var _motionEffectGroup: UIMotionEffectGroup?
    public var motionEffect: Double = 0 {
        didSet {
        
            if (motionEffect == 0 && _motionEffectGroup != nil) {
                
                self.removeMotionEffect(_motionEffectGroup!)
                _motionEffectGroup = nil
            
            } else {
                
                if !(_motionEffectGroup != nil) {
                    _motionEffectGroup = UIMotionEffectGroup()
                    self.addMotionEffect(_motionEffectGroup!)
                }
                
                let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
                
                xAxis.minimumRelativeValue = -motionEffect
                xAxis.maximumRelativeValue = motionEffect
                
                _motionEffectGroup!.motionEffects = [xAxis]
            }
        }
    }
    

}
