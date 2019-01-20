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
    
    init() {
        for variant in self.cartsianProductForCardsProperties() {
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
                } else {
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
        var thereIsAMatch = false
        let equalNumbers = Set<Int>([selectedCards[0].number, selectedCards[1].number, selectedCards[2].number]).count
        let equalSymbols = Set<Int>([selectedCards[0].symbol, selectedCards[1].symbol, selectedCards[2].symbol]).count
        let equalShadings = Set<Int>([selectedCards[0].shading, selectedCards[1].shading, selectedCards[2].shading]).count
        let equalColors = Set<Int>([selectedCards[0].color, selectedCards[1].color, selectedCards[2].color]).count
        if equalNumbers == 3 && equalSymbols == 3 && equalShadings == 3 && equalColors == 3 {
            print("Match because no equal chars")
            thereIsAMatch = true
        } else if equalNumbers == 1 && equalSymbols == 1 && equalShadings == 1 && equalColors == 1 {
            print("Match because equal chars")
            thereIsAMatch = true
        }
//        return thereIsAMatch
        
        // For debug
        return true
    }
    
    mutating func replaceCardsInTheSet() {
        print("replaceSelectedCards was called")
        if deck.count > 2 && setOnTable.count == 3 {
            for card in setOnTable {
                table[table.index(of: card)!] = deck.remove(at: 0)
            }
        } else {
            print("replaceSelectedCards() error in conditions: deck.count = \(deck.count), setOnTable.count = \(setOnTable.count)")
        }
    }
    
    mutating func addThreeCardsToTable() {
        print("addThreeCardsToTable was called")
        if deck.count > 2 && table.count < 22 {
            for _ in 0..<3 {
                table.append(deck.remove(at: 0))
            }
        } else {
            print("addTreeCardsToTable() error in conditions: deck.count = \(deck.count), table.count = \(table.count)")
        }
    }
    
    mutating func deal3MoreCards() {
        // replace cards in the set
        if setOnTable.count == 3 {
            replaceCardsInTheSet()
            selectedCards.removeAll()
            setOnTable.removeAll()
        } else {
            addThreeCardsToTable()
        }
    }
    
    func cartsianProductForCardsProperties() -> [[Int]]{
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
