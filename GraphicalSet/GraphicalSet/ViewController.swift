//
//  ViewController.swift
//  GraphicalSet
//
//  Created by Быков Алексей on 14/02/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = GraphicalSetGame()
    private let cardSymbols = ["▲", "●", "■"]
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet { self.updateView(from: self.game) }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet { self.updateScoreLabel(with: self.game.score) }
    }
    
    @IBAction func touchDeal3MoreCardsButton(_ sender: UIButton) {
        print("touched Deal button")
        self.game.deal3MoreCards()
        self.updateView(from: self.game)
    }
    
    @IBAction func touchStartNewGameButton(_ sender: UIButton) {
        print("touched New Game button")
        self.game = GraphicalSetGame()
        self.updateView(from: self.game)
    }
    
    @IBOutlet weak var deal3MoreCardsButton: UIButton! {
        didSet { self.toggleDeal3MoreCardsButton(from: self.game) }
    }
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            self.game.chooseCard(at: cardIndex)
            self.updateView(from: self.game)
        }
    }
    
    /// Разбить на функции
    private func updateView(from model: GraphicalSetGame) {
        self.toggleDeal3MoreCardsButton(from: model)
        self.updateScoreLabel(with: model.score)
        /// Кусок ниже тоже бы в отдельную функцию
        for index in self.cardButtons.indices {
            let button = self.cardButtons[index] /// про проверку границ надеюсь помнишь!
            self.hideCardButton(button: button)
            if index < model.table.count {
                let cardOnTheTable = model.table[index]
                self.applyCardSymbolsForButton(card: cardOnTheTable, button: button)
                self.drawBorderAroundCardButton(card: cardOnTheTable, button: button)
                if model.deck.count == 0 && model.matchedCards.contains(cardOnTheTable) {
                    self.hideCardButton(button: button)
                }
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
    
    private func updateScoreLabel(with newScore: Int) {
        if let scoreLabel = self.scoreLabel {
            scoreLabel.text = "Score: \(newScore)"
        }
    }
    
    private func toggleDeal3MoreCardsButton(from model: GraphicalSetGame) {
        // Turn on/off Deal3MoreCardsButton
        // Active
        // 1. Less then 24 cards on the table
        // 2. 24 cards and three chosen cards are a set
        // Disabled
        // 1. 24 cards on the table
        // 2. 24 cards and three chosen cards are not a set
        if let deal3MoreCardsButton = self.deal3MoreCardsButton {
            if model.deck.count > 2 && (model.table.count < 22 || model.setOnTable.count == 3) {
                deal3MoreCardsButton.isEnabled = true
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), for: .normal)
            } else {
                deal3MoreCardsButton.isEnabled = false
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            }
        }
    }
    
    private func applyCardSymbolsForButton(card: Card, button: UIButton) {
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: card.shading == 3 ? 8 : -1,
            .foregroundColor: self.getSymbolColorByPropertyValue(value: card.color)
                .withAlphaComponent(card.shading == 1 ? 0.25 : 1.0)
        ]
        let buttonTitle: NSAttributedString = NSAttributedString(
            string: String(repeating: self.cardSymbols[card.symbol - 1], count: card.number),
            attributes: buttonTitleAttributes
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
    }
    
    private func hideCardButton(button: UIButton) {
        button.setTitle("", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.layer.borderWidth = 0
    }
    
    private func drawBorderAroundCardButton(card: Card, button: UIButton) {
        button.layer.borderWidth = 0
        if self.game.isMaxNumerOfCardsSelected() {
            if self.game.setOnTable.contains(card) {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else if self.game.selectedCards.contains(card) {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        } else {
            if self.game.selectedCards.contains(card) {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
}

