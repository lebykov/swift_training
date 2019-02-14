//
//  Card.swift
//  GraphicalSet
//
//  Created by Быков Алексей on 14/02/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import Foundation

///--- Стуктуру здесь не смогли бы использовать ?
//TODO: почитать про структуры
class Card: Hashable {
    
    // making Card to conform to Hashable protocol
    // in swift 4.1 Hashable protocol conformance
    // is enabled by default
    var hashValue: Int { return self.identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.color == rhs.color
            && lhs.number == rhs.number
            && lhs.shading == rhs.shading
            && lhs.symbol == rhs.symbol
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
    ///--- Обычно все public методы/проперти документируются на русском языке в javadoc-стиле
    /// Для этого ставим курсом перед методом/пропертью и нажимаем cmd+alt+/ и дозаполянем
    /// Создать карту с указанными параметрами
    ///
    /// - Parameters:
    ///   - number: количество символов на карте
    ///   - symbol: идентификатор символа
    ///   - shading: идентификатор заливки символа
    ///   - color: идентификатор цвета
    init(number: Int, symbol: Int, shading: Int, color: Int) {
        self.identifier = Card.getUniqueIdentifier()
        self.color = color
        self.symbol = symbol
        self.shading = shading
        self.number = number
    }
}
