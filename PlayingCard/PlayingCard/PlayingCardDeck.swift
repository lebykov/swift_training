//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Быков Алексей on 26/01/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import Foundation

struct PlayingCardDeck
{
    private(set) var cards = [PlayingCard]()
    
    init() {
        //FIXME: чет я тож не придумаю
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
		return cards.count > 0 ? cards.remove(at: cards.count.arc4random) : nil
    }
}

extension Int {
    var arc4random: Int {
        switch self {
        case 1...:
            return Int(arc4random_uniform(UInt32(self)))
        case ..<0:
            return -Int(arc4random_uniform(UInt32(self)))
        default:
            return 0
        }
    }
}
