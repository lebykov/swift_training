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
        for n in 1...81 {
            deck.append(Card(number: n, symbol: n, shading: n, color: n))
        }
        
        // TODO
        // 1. shuffle deck
        // 2. generate all permutations for 3 elements of size four
        
        for index in 0..<12 {
            table.append(deck[index])
        }
        deck.removeSubrange(0..<12)
        
        print("created set game with \(deck.count) cards in the deck and \(table.count) cards on the table")

    }
    
    mutating func chooseCard(at index: Int) {
        print("choosed card at index: \(index)")
        
        if index >= table.count { return }
        if matchedCards.contains(table[index]) { return }
        
        let chosenCard = table[index]
        
        if selectedCards.count < 3 {
            if selectedCards.contains(chosenCard) {
                selectedCards.remove(at: selectedCards.index(of: chosenCard)!)
            } else {
                selectedCards.append(chosenCard)
            }
            
            if selectedCards.count == 3 {
                if checkForMatch() {
                    print("there is a match")
//                    matchedCards += selectedCards
                    setOnTable += selectedCards
                } else {
                    print("there is no match")
                }
            }
        } else {
            // choose card after evaluation
            // TODO check that there are cards left in the Deck
            
            if setOnTable.count == 3 {
                // there is a match
                matchedCards += selectedCards
                replaceCardsInTheSet()
                
                selectedCards.removeAll()

                if !setOnTable.contains(chosenCard) {
                    print("touched card is not in the set")
                    
                    selectedCards.append(chosenCard)
                }
                
                setOnTable.removeAll()
                
            } else {
                // there is no match
                selectedCards.removeAll()
                selectedCards.append(chosenCard)
            }
        }
    }

    
    mutating func checkForMatch() -> Bool {

        if selectedCards.count != 3 { return false }
        
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
        
        return thereIsAMatch
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
}
