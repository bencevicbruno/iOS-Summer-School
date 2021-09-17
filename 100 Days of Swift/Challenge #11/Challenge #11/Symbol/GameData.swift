//
//  GameData.swift
//  Challenge #11
//
//  Created by Bruno Benčević on 8/27/21.
//

import Foundation

class GameData {
    static var symbols = [String: String]()
    
    static func initialize() {
        symbols = [
            "Star-Struck": "🤩",
            "Cold Face": "🥶",
            "Pile of Poo": "💩",
            "Alien": "👽",
            "Thumbs Up": "👍",
            "Eyes": "👀",
            "Red Heart": "❤️",
            "Pizza": "🍕",
            "Fox": "🦊",
            "Fire": "🔥"
        ]
    }
    
    static func getSymbolsForAGame() -> [String: String] {
        var keys = symbols.map {$0.key}
        keys.shuffle()
        
        var gameDictionary = [String: String]()
        for i in 0 ..< 10 {
            gameDictionary[keys[i]] = symbols[keys[i]]
        }
        
        print("New game:", gameDictionary)
        
        return gameDictionary
    }
    
    static func addSymbol(name: String, emoji: String) -> String? {
        if symbols[name] != nil {
            return "Symbol already in the game!"
        } else {
            symbols[name] = emoji
            return nil
        }
    }
    
    static func removeSymbol(name: String) -> String? {
        if symbols.count == 10 {
            return "A minimum of 10 symbols are required for a game!"
        } else {
            symbols.removeValue(forKey: name)
            return nil
        }
    }
}
