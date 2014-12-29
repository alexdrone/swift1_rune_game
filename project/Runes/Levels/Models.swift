//
//  Models.swift
//  Runes
//
//  Created by Alex Usbergo on 29/12/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import Foundation

private func _createCurrentPlayer(Void) -> Player {
    return Player()
}

private let _currentPlayer = _createCurrentPlayer()

public protocol PlayerDelegate : NSObjectProtocol {
    
    /// Called when the player updates its scores
    func player(player: Player, onScoreChange:(old: Int, current: Int))
}

public class Player : NSObject {

    //the shared instance for the current player
    class var currentPlayer: Player {
        return _currentPlayer
    }
    
    public var score: Int = 0 {
        didSet {
            self.delegate?.player(self, onScoreChange: (old: oldValue, current: score))
        }
    }
    
    //contains all the observers
    public weak var delegate: PlayerDelegate?
}
