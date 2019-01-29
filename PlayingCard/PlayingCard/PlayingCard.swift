//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Быков Алексей on 26/01/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {

	var description: String {
        return "\(self.rank) \(self.suit)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
		
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♦️"
        case clubs = "♣️"
		
		var description: String { return self.rawValue }
		
		///--- c swift 4 надо юзать протокол CaseIterable и свойство .allCases
		static var all: [Suit] = [.spades, .hearts, .diamonds, .clubs]
    }
	
    enum Rank: CustomStringConvertible {
		
        case ace
        case face(String)
        case numeric(Int)
		
		var description: String {
			switch self {
			case .ace: return "A"
			case Rank.numeric(let pips): return String(pips)
			case Rank.face(let kind): return kind
			}
		}
		
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            //FIXME: юзаем функциональщину и фишки свифта
			let allRanks2 = (2...10).map { Rank.numeric($0) }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }
}
