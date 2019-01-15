//
//  Concentration.swift
//  Concertration
//
//  Created by Быков Алексей on 31.03.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import Foundation

// Changed from class to struct, since Concentration is not passed around, just sits in controller
struct Concentration
{
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0  // Assignment 1. Moving flipCount out of ViewController
    private(set) var score = 0      // Assignment 1. Adding score
    
    private(set) lazy var firstOfTwoFlipsDate: Date = Date()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return self.cards.indices.filter { self.cards[$0].isFaceUp }.oneAndOnly
        }
        
        set { // newValue parameter is omitted in method signature, but is accessible in func body
            for index in self.cards.indices {
                self.cards[index].isFaceUp = index == newValue // nice!!!
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            self.cards += [card, card] // another way to write upper 2 lines
        }
        // TODO: Shuffle the cards
        self.cards.shuffle()
    }
    
    func timeBonus(for seconds:Double) -> Int {
        /// Тут точно switch заюзать надо
        switch seconds {
        case let duration where 0.0.isLess(than: duration) && duration.isLess(than: 1.0):
            print("super fast!!! \(seconds)")
            return 3
        case let duration where 1.0.isLessThanOrEqualTo(duration) && duration.isLess(than: 2.0):
            print("norm! \(seconds)")
            return 2
        default:
            print("too slow... \(seconds)")
            return 1
        }
    }
    ///--- Слишком большая функция, надо разбить на несколько, читать ее - крайне сложно
    mutating func chooseCard(at index: Int) {     // added mutating when converted from class to struct, since struct is value type
        assert(self.cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen index not in the cards")
        
        if !self.cards[index].isFaceUp {
            self.flipCount += 1 // Assignment 1. Moving flipCount out of ViewController
        }
        
        ///--- большая вложенность, надо править (много if-ов)
        if !self.cards[index].isMatched {
            print("if !cards[index].isMatched branch")
            if let matchIndex = self.indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                print("\tif let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index branch")
                // check if cards is match
                if self.cards[matchIndex] == self.cards[index] {
                    // two cards matched
                    print("\t\tif cards[matchIndex] == cards[index] branch")
                    print("\t\tcards matched")
                    self.cards[matchIndex].isMatched = true
                    self.cards[index].isMatched = true
//                    score += 2      // Assignment 1. Adding score
                    
                    let matchTapDate = Date()
                    let interval = matchTapDate.timeIntervalSince(self.firstOfTwoFlipsDate)
                    
                    self.score += self.timeBonus(for: Double(interval))
                    
                } else {            // Assignment 1. Adding score
                    // cards don't match
                    if self.cards[index].isSeen {
                        self.score -= 1
                    }
                    if self.cards[matchIndex].isSeen {
                        self.score -= 1
                    }
                }
                self.cards[index].isFaceUp = true
                self.cards[index].isSeen = true  // Assignment 1. Adding score
                self.cards[matchIndex].isSeen = true // Assignment 1. Adding score
            } else {
                // click when none of cards is face up
                print("\telse branch")
                // either no cards or 2 cards are face up
                self.firstOfTwoFlipsDate = Date()
                
                print("First of two cards tapped on: \(firstOfTwoFlipsDate)")
                
                self.indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

// MARK: Extensions

extension Collection {
    var oneAndOnly: Element? {
        return self.count == 1 ? first : nil
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        /// всегда пишем полные нзвания переменных, не сокращаем имена, это повышает читаемость
        let collectionCount = self.count
        guard collectionCount > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: collectionCount, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let delta: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let swapIndex = index(firstUnshuffled, offsetBy: delta)
            swapAt(firstUnshuffled, swapIndex)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
