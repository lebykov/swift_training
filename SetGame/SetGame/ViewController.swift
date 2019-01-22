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
    private let cardSymbols = ["▲", "●", "■"]

    @IBOutlet var cardButtons: [UIButton]! {
        didSet { self.updateViewFromModel() }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet { self.updateScoreLabel(to: self.game.score) }
    }
    
    @IBAction func touchDeal3MoreCardsButton(_ sender: UIButton) {
        print("touched Deal button")
        self.game.deal3MoreCards()
        self.updateViewFromModel()
        self.toggleDeal3MoreCardsButton()
    }
    
    @IBAction func touchStartNewGameButton(_ sender: UIButton) {
        print("touched New Game button")
        self.game = SetGame()
        self.updateViewFromModel()
        self.toggleDeal3MoreCardsButton()
        self.updateScoreLabel(to: self.game.score)
    }
    
    @IBOutlet weak var deal3MoreCardsButton: UIButton! {
        didSet { self.toggleDeal3MoreCardsButton() }
    }
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            self.game.chooseCard(at: cardIndex)
            self.updateViewFromModel()
            self.toggleDeal3MoreCardsButton()
            self.updateScoreLabel(to: self.game.score)
        }
        
        print("touched card")
    }
    
    /// Разбить на функции
    private func updateViewFromModel() {
        
        for index in self.cardButtons.indices {
            let button = self.cardButtons[index]
            
            if index < self.game.table.count {
                let cardOnTheTable = self.game.table[index]
                print(">>> Card \(cardOnTheTable.number) for button \(self.cardButtons[index])")
                
                let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
                    .strokeWidth: cardOnTheTable.shading == 3 ? 8 : -1,
                    .foregroundColor: self.getSymbolColorByPropertyValue(value: cardOnTheTable.color)
                        .withAlphaComponent(cardOnTheTable.shading == 1 ? 0.25 : 1.0)
                ]
                let buttonTitle: NSAttributedString = NSAttributedString(
                    string: String(repeating: self.cardSymbols[cardOnTheTable.symbol - 1], count: cardOnTheTable.number),
                    attributes: buttonTitleAttributes
                )
                
                button.setAttributedTitle(buttonTitle, for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
                
                if self.game.selectedCards.count != 3 {
                    if self.game.selectedCards.contains(game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    } else {
                        button.layer.borderWidth = 0
                    }
                } else if self.game.selectedCards.count == 3 {
                    if self.game.setOnTable.contains(self.game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    } else if self.game.selectedCards.contains(self.game.table[index]) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    } else {
                        button.layer.borderWidth = 0
                    }
                }
                
                if self.game.deck.count == 0 && self.game.matchedCards.contains(self.game.table[index]) {
                    button.setTitle("", for: .normal)
                    button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                }
            } else {
                button.setTitle("", for: .normal)
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    private func getSymbolColorByPropertyValue(value: Int) -> (UIColor) {
        switch value {
        case 1:
            return UIColor.cyan
        case 2:
            return UIColor.magenta
        case 3:
            return UIColor.yellow
        default:
            return UIColor.red
        }
    }
    
    private func updateScoreLabel(to newScore: Int) {
        self.scoreLabel.text = "Score: \(newScore)"
    }
    
    private func toggleDeal3MoreCardsButton() {
        // Turn on/off Deal3MoreCardsButton
        // Active
        // 1. Less then 24 cards on the table
        // 2. 24 cards and three chosen cards are a set
        // Disabled
        // 1. 24 cards on the table
        // 2. 24 cards and three chosen cards are not a set
        if self.game.deck.count > 2 {
            if self.game.table.count < 22 || game.setOnTable.count == 3 {
                print("else")
                self.deal3MoreCardsButton.isEnabled = true
                self.deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), for: .normal)
            } else {
                print("deck.count < 3")
                self.deal3MoreCardsButton.isEnabled = false
                self.deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            }
        } else {
            print("deck.count < 3")
            self.deal3MoreCardsButton.isEnabled = false
            self.deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        }
    }
}

