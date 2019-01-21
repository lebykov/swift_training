//
//  SetGame.swift
//  SetGame
//
//  Created by Быков Алексей on 14.04.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import Foundation

struct SetGame {
    var deck = [Card]()
    var table = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var setOnTable = [Card]()
    var score = 0
    
    init() {
        for variant in self.cartesianProductForCardsProperties() {
            self.deck.append(Card(number: variant[0], symbol: variant[1], shading: variant[2], color: variant[3]))
        }
        self.deck.shuffle()
        for index in 0..<12 {
            self.table.append(self.deck[index])
        }
        self.deck.removeSubrange(0..<12)
        
        print("created set game with \(self.deck.count) cards in the deck and \(self.table.count) cards on the table")
    }
    
    mutating func chooseCard(at index: Int) {
        print("choosed card at index: \(index)")
        
        if index >= self.table.count { return }
        if self.matchedCards.contains(self.table[index]) { return }
        
        let chosenCard = self.table[index]
        
        if self.selectedCards.count < 3 {
            if self.selectedCards.contains(chosenCard) {
                self.selectedCards.remove(at: self.selectedCards.index(of: chosenCard)!)
            } else {
                self.selectedCards.append(chosenCard)
            }
            if self.selectedCards.count == 3 {
                if self.checkForMatch() {
                    print("there is a match")
//                    matchedCards += selectedCards
                    self.setOnTable += self.selectedCards
                    self.score += 3
                } else {
                    self.score -= 5
                    print("there is no match")
                }
            }
        } else {
            // choose card after evaluation
            // TODO check that there are cards left in the Deck
            if self.setOnTable.count == 3 {
                // there is a match
                self.matchedCards += self.selectedCards
                self.replaceCardsInTheSet()
                self.selectedCards.removeAll()
                if !self.setOnTable.contains(chosenCard) {
                    print("touched card is not in the set")
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
        if self.selectedCards.count != 3 { return false }
        let acceptableValues = [1, 3]
        var thereIsAMatch = false
        let equalNumbers = Set<Int>(self.selectedCards.map { $0.number }).count
        let equalSymbols = Set<Int>(self.selectedCards.map { $0.symbol }).count
        let equalShadings = Set<Int>(self.selectedCards.map { $0.shading }).count
        let equalColors = Set<Int>(self.selectedCards.map { $0.color }).count
        
        if acceptableValues.contains(equalNumbers) && acceptableValues.contains(equalSymbols) && acceptableValues.contains(equalShadings) && acceptableValues.contains(equalColors) {
            print("checkForMatch(): Match")
            thereIsAMatch = true
        }
        return thereIsAMatch
        
        // For debug
//        return true
    }
    
    mutating func replaceCardsInTheSet() {
        print("replaceSelectedCards was called")
        if self.deck.count > 2 && self.setOnTable.count == 3 {
            for card in self.setOnTable {
                self.table[self.table.index(of: card)!] = self.deck.remove(at: 0)
            }
        } else {
            print("replaceSelectedCards() error in conditions: deck.count = \(self.deck.count), setOnTable.count = \(self.setOnTable.count)")
        }
    }
    
    mutating func addThreeCardsToTable() {
        print("addThreeCardsToTable was called")
        if self.deck.count > 2 && self.table.count < 22 {
            for _ in 0..<3 {
                self.table.append(self.deck.remove(at: 0))
            }
        } else {
            print("addTreeCardsToTable() error in conditions: deck.count = \(self.deck.count), table.count = \(self.table.count)")
        }
    }
    
    mutating func deal3MoreCards() {
        // replace cards in the set
        if self.setOnTable.count == 3 {
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
