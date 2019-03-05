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
        if !cardsContainer.bounds.height.isEqual(to: 0.0) {
            return cardsContainer.bounds.width / cardsContainer.bounds.height ///DONE: проверка на ноль где ?
        } else {
            return 1.0
        }
    }
    
    @IBOutlet weak var cardsContainer: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self,  ///OK: такой перенос предпочтительней у нас в проекте
                                                 action: #selector(self.handleSwipeCardsContainerView(_:)))
            swipe.direction = [.down]
            self.cardsContainer.addGestureRecognizer(swipe)
            
            let rotation = UIRotationGestureRecognizer(target: self,
                                                       action: #selector(self.handleRotationCardsContainerView(_:)))
            self.cardsContainer.addGestureRecognizer(rotation)
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet { self.updateScoreLabel(with: self.game.score) }
    }
    
    @IBAction func touchDeal3MoreCardsButton(_ sender: UIButton) {
        self.game.deal3MoreCards()
        self.updateView(from: self.game)
    }
    
    @IBAction func touchStartNewGameButton(_ sender: UIButton) {
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
        self.cardsContainer.subviews.forEach { $0.removeFromSuperview() }  //OK: здесь лучше foreach заюзать вместо compactMap, тогда присваивание не понадобится
        self.grid.frame = self.cardsContainer.bounds
        self.grid.cellCount = self.game.table.count
        for index in 0..<self.game.table.count {
            self.setUpCardView(at: index) ///DONE: вот этот кусок и ниже лучше в отдельную функцию
        }
    }
    
    private func getCardView(for card: Card, in frame: CGRect) -> CardView {
        let cardView = CardView(frame: frame.insetBy(dx: frame.size.width * 0.05,
                                                     dy: frame.size.width * 0.05))
        cardView.color = card.color
        cardView.number = card.number
        cardView.shading = card.shading
        cardView.symbol = card.symbol
        return cardView
    }
    
    private func setUpCardView(at index: Int) {
        if let cardFrame = self.grid[index], index < self.game.table.count {
            let card = self.game.table[index]
            let cardView = self.getCardView(for: card, in: cardFrame)
            self.drawBorderAroundCardView(card: card, cardView: cardView)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(self.handleTapCardView(_:)))
            cardView.addGestureRecognizer(tapGestureRecognizer)
            
            self.cardsContainer.addSubview(cardView)
        } else {
            print("setUpCardView(at index: Int): self.grid[\(index))] returned nil")
        }
    }
    
    @objc private func handleTapCardView(_ gestureRecognizer: UIGestureRecognizer) {
        if let cardView = gestureRecognizer.view as? CardView { //DONE: форс не используем и надо записать с помощью одного if
            if let cardIndex = cardsContainer.subviews.firstIndex(of: cardView) {
                self.game.chooseCard(at: cardIndex)
                self.updateView(from: self.game)
            }
        }
    }
    
    @objc private func handleSwipeCardsContainerView(_ gestureRecognizer: UIGestureRecognizer) {
        if self.game.deck.count > self.game.maxNumberOfSelectedCards - 1
            || self.game.setOnTable.count == self.game.numberOfCardsInSet {  //DONE: магические цифры лучше в константы
            self.game.deal3MoreCards()
            self.updateView(from: self.game)
        }
    }
    
    @objc private func handleRotationCardsContainerView(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            self.game.shuffleRemainingCards()
            self.updateView(from: self.game)
        default:
            print("default")
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
            if model.deck.count > model.maxNumberOfSelectedCards - 1
                || model.setOnTable.count == model.numberOfCardsInSet { //DONE: магические цифры точно в константы
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
        if self.game.isMaxNumerOfCardsSelected { //HOW TO?: здесь лучше guard, тогда цикломатическая сложность уменьшиться вроде
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

