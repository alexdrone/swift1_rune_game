//
//  Appearance.swift
//  Runes
//
//  Created by Alex Usbergo on 28/07/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit

// The default color palette used by the kit
public enum ColorSwatch : UInt32 {
    
    //general
    case White = 0xffffff
    case Gray = 0x4B5660
    case Black = 0x2B2b2a
    case LightGreen = 0xb8e986
    case LightBlue = 0x252c2c
    
    //dots
    case Green = 0x9fc2a4
    case Blue = 0x5e8Bba
    case Red = 0xf58594
    case Yellow = 0xfce396
    case Purple = 0x9b85f5
    
    // Returns a random color
    public static func random() -> ColorSwatch {
        return self.fromInteger(Int(arc4random_uniform(5)))
    }
    
    /// Creates a color swatch from a given integer
    public static func fromInteger(integer: Int) -> ColorSwatch {
        
        switch integer % 5 {
            case 0: return .Green
            case 1: return .Blue
            case 2: return .Red
            case 3: return .Yellow
            case 4: return .Purple
            
            default: return .Black
        }
    }
    
    /// Returns the color associated with the color swatch
    public func color(alpha: CGFloat = 1) -> UIColor {
        return UIColor.colorWithRGB888(self.rawValue, alpha: alpha)
    }
    
    public func __conversion() -> UIColor {
        return self.color(alpha: 1)
    }
}

/// The typography classes (point sizes)
public enum TypographySize: CGFloat {
    
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
public enum TypographyTrait: String {
    
    case Italic = "QuickSand-Italic"
    case Light = "QuickSand-Light"
    case Regular = "QuickSand-Regular"
    case Semibold = "QuickSand-Semibold"
    case Bold = "QuickSand-Bold"
    case Dash = "QuicksandDash-Regular"
    case Glyph = "VIKING,-ELDER-Runes-Bold"
}

public struct Typography {
    
    let trait: TypographyTrait;
    let size: TypographySize;
    
    // Returns the font associated with this typography description
    public func __conversion() -> UIFont {
        return UIFont(name: trait.rawValue, size: size.rawValue)!
    }
}

// The glyphs used in the game
public enum Glyph: String {
    
    case X = "X"
    case Z = "S"
    case T = "Y"
    case O = "O"
    case J = "F"
    
    /// Returns a glyph from the given integer
    public static func fromInteger(integer: Int) -> Glyph {
        
        switch integer % 5 {
            case 0: return .X
            case 1: return .Z
            case 2: return .T
            case 3: return .O
            case 4: return .J
                
            default: return .X
        }
    }
    
    // Returns a random glyph
    public static func random() -> Glyph {
        return self.fromInteger(Int(arc4random_uniform(5)))
    }
    
    public func __conversion() -> String {
        return self.rawValue
    }
}


