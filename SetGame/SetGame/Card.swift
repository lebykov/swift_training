//
//  Card.swift
//  SetGame
//
//  Created by Быков Алексей on 14.04.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import Foundation
class Card: Hashable {
    
    // making Card to conform to Hashable protocol
    // in swift 4.1 Hashable protocol conformance
    // is enabled by default
    var hashValue: Int { return identifier}

    static func ==(lhs: Card, rhs:Card) -> Bool {
        return
            lhs.identifier == rhs.identifier &&
            lhs.color == rhs.color &&
            lhs.number == rhs.number &&
            lhs.shading == rhs.shading &&
            lhs.symbol == rhs.symbol
    }
    
    private var identifier: Int
    private(set) var number: Int
    private(set) var symbol: Int
    private(set) var shading: Int
    private(set) var color: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.identifier = Card.getUniqueIdentifier()
        self.color = color
        self.symbol = symbol
        self.shading = shading
        self.number = number
    }
}
