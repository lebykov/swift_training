//
//  ViewController.swift
//  SetGame
//
//  Created by Быков Алексей on 14.04.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = SetGame()


    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            updateViewFromModel()
            print("Symbols are: \(symbols)")
        }
    }
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    @IBAction func touchDeal3MoreCardsButton(_ sender: UIButton) {
        print("touched Deal button")
        game.deal3MoreCards()
        updateViewFromModel()
        toggleDeal3MoreCardsButton()
    }
    
    
    @IBAction func touchStartNewGameButton(_ sender: UIButton) {
        print("touched New Game button")
        game = SetGame()
        symbols = Array(101...181) // for development only
        updateViewFromModel()
        toggleDeal3MoreCardsButton()
    }
    
    
    @IBOutlet weak var deal3MoreCardsButton: UIButton! {
        didSet {
            toggleDeal3MoreCardsButton()
        }
    }
    

    @IBAction func touchCardButton(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
            toggleDeal3MoreCardsButton()
        }
        
        print("touched card")
    }
    
    private func updateViewFromModel() {
        
        // TODO
        for index in cardButtons.indices {
            let button = cardButtons[index]
            
            if index < game.table.count {
//                print("updating button with index \(index), setting Title to \(symbols[game.table[index].number - 1])")
//                print("game.table[index].number: \(game.table[index].number)")
                button.setTitle(String(symbols[game.table[index].number - 1]), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
                if game.selectedCards.count != 3 {
                    if game.selectedCards.contains(game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    } else {
                        button.layer.borderWidth = 0
                    }
                } else if game.selectedCards.count == 3 {
                    if game.setOnTable.contains(game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    } else if game.selectedCards.contains(game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    } else {
                        button.layer.borderWidth = 0
                    }
                }
                
                if game.deck.count == 0 && game.matchedCards.contains(game.table[index]) {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                }
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    private func toggleDeal3MoreCardsButton() {
        // Turn on/off Deal3MoreCardsButton
        // Active
        // 1. Less then 24 cards on the table
        // 2. 24 cards and three chosen cards are a set
        // Disabled
        // 1. 24 cards on the table
        // 2. 24 cards and three chosen cards are not a set
        if game.deck.count > 2 {
            if game.table.count < 22 || game.setOnTable.count == 3 {
                print("else")
                deal3MoreCardsButton.isEnabled = true
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), for: UIControlState.normal)
            } else {
                print("deck.count < 3")
                deal3MoreCardsButton.isEnabled = false
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: UIControlState.normal)
            }
        } else {
            print("deck.count < 3")
            deal3MoreCardsButton.isEnabled = false
            deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: UIControlState.normal)
        }
    }
    
    private var symbols = Array(101...181) // for development only
    
    
}

