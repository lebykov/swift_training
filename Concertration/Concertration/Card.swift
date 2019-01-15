//
//  Card.swift
//  Concertration
//
//  Created by Быков Алексей on 31.03.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    // making Card to conform to Hashable protocol
    var hashValue: Int { return identifier }
    ///--- Синтаксис приводим в порядок, инит выносим повыше, так как самая важная штука, остальное группируем логически
    
    var isFaceUp = false
    var isMatched = false
    var isSeen = false

    private var identifier: Int
    private static var identifierFactory = 0 ///--- хранить состояние в статик переменной - не самое лучшее

    // create card with unique identifier
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
//    init(identifier: Int) {
//        self.identifier = identifier
//    }
    
}
