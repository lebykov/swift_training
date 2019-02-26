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
    
    private lazy var grid = Grid(layout: Grid.Layout.aspectRatio(self.cardsContainerAspectRatio))
    private var cardsContainerAspectRatio: CGFloat {
        return cardsContainer.bounds.width / cardsContainer.bounds.height
    }
    
    @IBOutlet weak var cardsContainer: UIView!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateView(from: self.game)
    }
    
    private func manageCardViews() {
        let _ = self.cardsContainer.subviews.compactMap { $0.removeFromSuperview() }
        self.grid.frame = self.cardsContainer.bounds
        self.grid.cellCount = self.game.table.count
        for index in 0..<self.game.table.count {
            if let cardFrame = self.grid[index] {
                let cardView = CardView(frame: cardFrame.insetBy(dx: cardFrame.size.width * 0.05, dy: cardFrame.size.width * 0.05))
                let card = self.game.table[index]
                cardView.color = card.color
                cardView.number = card.number
                cardView.shading = card.shading
                cardView.symbol = card.symbol
                self.cardsContainer.addSubview(cardView)
                
                let tapGestureRecognizer = UITapGestureRecognizer(
                    target: self, action: #selector(self.handleTapCardView(_:)))
                cardView.addGestureRecognizer(tapGestureRecognizer)
                
                self.drawBorderAroundCardView(card: self.game.table[index], cardView: cardView)
            } else {
                print("manageCardViews(): self.grid[\(index))] returned nil")
            }
        }
    }
    
    @objc private func handleTapCardView(_ gestureRecognizer: UIGestureRecognizer) {
        let cardView: CardView = gestureRecognizer.view as! CardView
        if let cardIndex = cardsContainer.subviews.firstIndex(of: cardView) {
            self.game.chooseCard(at: cardIndex)
            self.updateView(from: self.game)
        }
    }
    
    /// Разбить на функции - done
    private func updateView(from model: GraphicalSetGame) {
        self.toggleDeal3MoreCardsButton(from: model)
        self.updateScoreLabel(with: model.score)
        self.manageCardViews()
    }
    
    private func updateScoreLabel(with newScore: Int) {
        if let scoreLabel = self.scoreLabel {
            scoreLabel.text = "Score: \(newScore)"
        }
    }
    
    private func toggleDeal3MoreCardsButton(from model: GraphicalSetGame) {
        if let deal3MoreCardsButton = self.deal3MoreCardsButton {
            if model.deck.count > 2 || model.setOnTable.count == 3 {
                deal3MoreCardsButton.isEnabled = true
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), for: .normal)
            } else {
                deal3MoreCardsButton.isEnabled = false
                deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
            }
        }
    }

    private func drawBorderAroundCardView(card: Card, cardView: CardView) {
        cardView.layer.borderWidth = 0
        if self.game.isMaxNumerOfCardsSelected() {
            if self.game.setOnTable.contains(card) {
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else if self.game.selectedCards.contains(card) {
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        } else {
            if self.game.selectedCards.contains(card) {
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
}

