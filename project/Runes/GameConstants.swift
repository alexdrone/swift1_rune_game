//
//  GameConstants.swift
//  Runes
//
//  Created by Alex Usbergo on 29/12/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import Foundation

public enum PointModifier : Int {
    
    case PointsPerSelectedDot = 8
    case PointsPerSecond = 4
    
    /// Returns the new score after applying the modifier
    public func scoreByApplyingModifier(score: Int, modifier: PointModifier, times: Int = 1) -> Int {
        return score + (modifier.rawValue * times)
    }
}