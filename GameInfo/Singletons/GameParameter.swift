//
//  GameParameter.swift
//  GameInfo
//
//  Created by Djaka Permana on 05/06/23.
//

import Foundation

class GameParameter {
    public static var shared = GameParameter()
    
    private var gameId: Int?
    
    func setGameId(id: Int) {
        self.gameId = id
    }
    
    func getGameId() -> Int {
        return gameId ?? 0
    }
}
