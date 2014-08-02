// Playground - noun: a place where people can play

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


/// The default color palette used by the kit
enum ColorSwatch : UInt32 {
    
    case White = 0xffffff
    case Black = 0x4B5660
    case Green = 0x9fc2a4
    case Blue = 0x5e8Bba
    case Red = 0xf58594
    case Yellow = 0xfce396
    case Purple = 0x9b85f5
    
    /// Returns the color associated with the color swatch
    func color(alpha: CGFloat = 1) -> UIColor {
        return UIColor.colorWithRGB888(self.toRaw(), alpha: alpha)
    }
    
    func __conversion() -> UIColor {
        return self.color(alpha: 1)
    }
}

/// The typography classes (point sizes)
enum TypographySize: CGFloat {
    
    case SuperSmall = 10.0
    case ExtreSmall = 12.0
    case Small = 14.0
    case Medium = 18.0
    case MediumLarge = 22.0
    case Large = 32.0
    case ExtraLarge = 43.0
    case SuperLarge = 90.0
}

/// The typography classes
enum TypographyTrait: String {
    
    case Italic = "QuickSand-Italic"
    case Light = "QuickSand-Light"
    case Regular = "QuickSand-Regular"
    case Semibold = "QuickSand-Semibold"
    case Bold = "QuickSand-Bold"
    case Dash = "QuicksandDash-Regular"
    case Icon = "VIKING,-ELDER-Runes-Bold"
}

struct Typography {
    
    let trait: TypographyTrait;
    let size: TypographySize;
    
    // Returns the font associated with this typography description
    func __conversion() -> UIFont {
        return UIFont(name: self.trait.toRaw(), size:self.size.toRaw())
    }
}


var str = "Hello, playground"

var c = ColorSwatch.Blue
var v = UIView()

v.backgroundColor = c



