//
//  SetGame.swift
//  SetGame
//
//  Created by Быков Алексей on 14.04.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import Foundation

///---- Название класса станное
struct SetGame {
	
    var deck = [Card]()
    var table = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var setOnTable = [Card]()
    var score = 0
    
    ///----избегаем дублирования
	///--- артикли в нейминге не используем
    // константы
    let numberOfCardsOnTable = 12
    let maxNumberOfSelectedCards = 3
    let scorePoints = 3
    let penaltyPoints = 5
    let numberOfCardsInSet = 3
    
    init() {
        for variant in self.cartesianProductForCardsProperties() {
            self.deck.append(Card(number: variant[0],
								  symbol: variant[1],
								  shading: variant[2],
								  color: variant[3]))
        }
        self.deck.shuffle()
        
        for index in 0..<self.numberOfCardsOnTable {
            self.table.append(self.deck[index])
        }
        self.deck.removeSubrange(0..<self.numberOfCardsOnTable)
    }
    
    func isMaxNumerOfCardsSelected() -> (Bool) {
        return self.selectedCards.count == self.maxNumberOfSelectedCards
    }
    
    ///---- метод большой, многа букаф читать сложна непанятна!
	///---- метод так и не разбил
    mutating func chooseCard(at index: Int) {
        print("choosed card at index: \(index)")
        
        if index >= self.table.count { return }
        if self.matchedCards.contains(self.table[index]) { return }
        
        let chosenCard = self.table[index]
        
        if self.selectedCards.count < self.maxNumberOfSelectedCards {
            if self.selectedCards.contains(chosenCard) {
                self.selectedCards.remove(at: self.selectedCards.index(of: chosenCard)!)
            } else {
                self.selectedCards.append(chosenCard)
            }
            if self.isMaxNumerOfCardsSelected() {
                if self.checkForMatch() {
                    self.setOnTable += self.selectedCards
                    self.score += self.scorePoints // эта тройка как-то сввязано с тройкой сверху ? непонятно, потому что не используем константы
                } else {
                    self.score -= self.penaltyPoints
                }
            }
        } else {
            // choose card after evaluation
            // TODO check that there are cards left in the Deck
            if self.setOnTable.count == self.maxNumberOfSelectedCards {
                // there is a match
                self.matchedCards += self.selectedCards
                self.replaceCardsInTheSet()
                self.selectedCards.removeAll()
                if !self.setOnTable.contains(chosenCard) {
                    self.selectedCards.append(chosenCard)
                }
                self.setOnTable.removeAll()
            } else {
                // there is no match
                self.selectedCards.removeAll()
                self.selectedCards.append(chosenCard)
            }
        }
    }

    mutating func checkForMatch() -> Bool {
        if self.selectedCards.count != self.maxNumberOfSelectedCards { return false }
        let acceptableValues = [1, 3]
        /// булевые переменные стараемся называть на is... (isEnabled isLocked и тд)
        var isMatch = false
        let equalNumbers = Set<Int>(self.selectedCards.map { $0.number }).count
        let equalSymbols = Set<Int>(self.selectedCards.map { $0.symbol }).count
        let equalShadings = Set<Int>(self.selectedCards.map { $0.shading }).count
        let equalColors = Set<Int>(self.selectedCards.map { $0.color }).count
        
        isMatch = acceptableValues.contains(equalNumbers)
            && acceptableValues.contains(equalSymbols)
            && acceptableValues.contains(equalShadings)
            && acceptableValues.contains(equalColors)
        return isMatch
    }
    
    mutating func replaceCardsInTheSet() {
        if self.deck.count > 2 && self.setOnTable.count == self.numberOfCardsInSet {
            for card in self.setOnTable {
                self.table[self.table.index(of: card)!] = self.deck.remove(at: 0)
            }
        }
    }
    
    mutating func addThreeCardsToTable() {
        if self.deck.count > 2 && self.table.count < 22 {
            for _ in 0..<3 {
                self.table.append(self.deck.remove(at: 0))
            }
        }
    }
    
    mutating func deal3MoreCards() {
        // replace cards in the set
        if self.setOnTable.count == self.numberOfCardsInSet {
            self.replaceCardsInTheSet()
            self.selectedCards.removeAll()
            self.setOnTable.removeAll()
        } else {
            self.addThreeCardsToTable()
        }
    }
    
    func cartesianProductForCardsProperties() -> [[Int]]{
        let numbersList = [1, 2, 3]
        var productList: [[Int]] = []
        ///---Жесть)
        /// Похоже простого решения нет - https://stackoverflow.com/questions/43331168/swift-lazy-cartesian-product
        /// https://github.com/Oyvindkg/SwiftProductGenerator
        for element1 in numbersList {
            for element2 in numbersList {
                for element3 in numbersList {
                    for element4 in numbersList {
                        productList.append([element1, element2, element3, element4])
                    }
                }
            }
        }
        return productList
    }
}
