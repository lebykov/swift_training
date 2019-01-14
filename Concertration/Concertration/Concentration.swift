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
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    }
//                    else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        
        set { // newValue parameter is omitted in method signature, but is accessible in func body
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue) // nice!!!
            }
        }
    }
    
    func timeBonus(for seconds:Double) -> Int {
        if 0.0.isLess(than: seconds) && seconds.isLess(than: 1.0) {
            print("super fast!!! \(seconds)")
            return 3
        }
        else if 1.0.isLessThanOrEqualTo(seconds) && seconds.isLess(than: 2.0) {
            print("norm! \(seconds)")
            return 2
        }
        else {
            print("too slow... \(seconds)")
            return 1
        }
    }
    
    mutating func chooseCard(at index: Int) {     // added mutating when converted from class to struct, since struct is value type
//        if cards[index].isFaceUp {
//            cards[index].isFaceUp = false
//        } else {
//            cards[index].isFaceUp = true
//        }
        
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen index not in the cards")
        
        if !cards[index].isFaceUp {
            flipCount += 1 // Assignment 1. Moving flipCount out of ViewController
        }
        
        if !cards[index].isMatched {
            print("if !cards[index].isMatched branch")
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                print("\tif let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index branch")
                // check if cards is match
                if cards[matchIndex] == cards[index] {
                    // two cards matched
                    print("\t\tif cards[matchIndex] == cards[index] branch")
                    print("\t\tcards matched")
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
//                    score += 2      // Assignment 1. Adding score
                    
                    let matchTapDate = Date()
                    let interval = matchTapDate.timeIntervalSince(firstOfTwoFlipsDate)
                    
                    score += timeBonus(for: Double(interval))
                    
                } else {            // Assignment 1. Adding score
                    // cards don't match
                    if cards[index].isSeen {
                        score -= 1
                    }
                    if cards[matchIndex].isSeen {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
                cards[index].isSeen = true  // Assignment 1. Adding score
                cards[matchIndex].isSeen = true // Assignment 1. Adding score
                
//                indexOfOneAndOnlyFaceUpCard = nil // don't need since indexOfOneAndOnlyFaceUpCard is computed property
            } else {
                // click when none of cards is face up
                print("\telse branch")
                // either no cards or 2 cards are face up
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                    cards[index].isFaceUp = true
//                }
//                cards[index].isFaceUp = true // don't need commented out code since indexOfOneAndOnlyFaceUpCard is computed property
                
                firstOfTwoFlipsDate = Date()
                
                print("First of two cards tapped on: \(firstOfTwoFlipsDate)")
                
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            // let matchingCard = card // copies card since struct is a value type
//            cards.append(card)
//            cards.append(card) // copies card since struct is a value type
            cards += [card, card] // another way to write upper 2 lines
        }
        // TODO: Shuffle the cards
        cards.shuffle()
    }
}

// MARK: Extensions

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
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
