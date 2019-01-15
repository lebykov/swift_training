//
//  ViewController.swift
//  Concertration
//
//  Created by Быков Алексей on 24.03.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: self.numberOfPairsOfCards) // lazy means that variable is not initialized until someone grabs it. lazy cannot have a didSet(observable)
    
    var numberOfPairsOfCards: Int {    // no need to set private, if you want prop to be readable, but not writable because this is a computed prop is only gettable
            return (self.cardButtons.count + 1) / 2  // this is read only property, get{} is omitted
    }
    ///--- закоменченный код - зло
    
    ///---- Функции идут вперемешку с пропертями, обычно проперти сверху, затем функции, главное - всегда придерживаться одного стиля
    private var themes: [String: (emojis: String,
        backgroundColor: UIColor,
        cardBackColor: UIColor)] = ["sports": ("⚽️🏀🏈⚾️🎾🏐🏉🎱🥊🏓", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
                                    "food": ("🍔🍟🍕🥫🍩🥐🌮🥩🍲🥞", #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                                    "animals": ("🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯", #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)),
                                    "gadgets": ("⌚️📱💻📷📹🔦🎙📻🕹🖥", #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
                                    "vehicles": ("🚗🚕🚙🚌🚎🏎🚓🚑🚛🚜", #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
                                    "helloween": ("🦇😱🙀😈🎃👻🍭🍬🍎🕸", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))]
    
    private var theme: (emojis: String, backgroundColor: UIColor, cardBackColor: UIColor) = ("🦇😱🙀😈🎃👻🍭🍬🍎🕸", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    private lazy var emojiChoices = self.theme.emojis
    ///---- Придерживаемся единого стиля
    private var emoji = [Card: String]() // initialization of Dictionary

    ///---- Комментарии и документация к коду обычно пишется на русском, зачем лишний раз переводить и задумываться
    // almost always Outlets must be private
    @IBOutlet private weak var flipCountLable: UILabel! {
        didSet { self.updateFlipCountLabel(to: self.game.flipCount) }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {      // Assignment 1. Adding score
        ///--  Так симпатичнее
        didSet { self.updateScoreLabel(to: self.game.score) }
    }
    
    @IBOutlet weak var newGameButton: UIButton! {
        didSet { self.updateNewGameButtonTextColor() }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!  // or Arrya<UIButton> like in Java
    
    // MARK: Handle Card Touch Behaviour
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = self.cardButtons.index(of: sender) {
            self.game.chooseCard(at: cardNumber)
            self.updateFlipCountLabel(to: game.flipCount) // Assignment 1. Moving flipCount out of ViewController
            self.updateScoreLabel(to: game.score)    // Assignment 1. Adding score
            self.updateViewFromModel()
        } else {
          print("choosen card was not in cardButtons")
        }
    }
    
    // MARK: Assignment 1: New Game Button
    
    @IBAction func startNewGame(_ sender: UIButton) {
        ///---- Обращение к свойствам текущего класса или вызов методов - через self, так сразу понятно что это относится НЕ к локальным переменным
        self.game = Concentration(numberOfPairsOfCards: self.numberOfPairsOfCards)
        self.theme = self.chooseRandomTheme()
        self.emojiChoices = self.theme.emojis
        self.updateBackgroundColor()
        self.updateCardsBackColor()
        self.updateNewGameButtonTextColor()
        self.updateViewFromModel()
        self.updateScoreLabel(to: self.game.score)
        self.updateFlipCountLabel(to: self.game.flipCount)
    }
    ///---- где то две строки пустых, а где то одна - не единообразно
    
    private func updateBackgroundColor() {
        self.view.backgroundColor = self.theme.backgroundColor
    }
    
    private func updateCardsBackColor() {
        for button in self.cardButtons {
            button.backgroundColor = self.theme.cardBackColor
        }
    }
    
    private func updateFlipCountLabel(to flipCount: Int) {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : self.theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        self.flipCountLable.attributedText = attributedString
    }
    
    private func updateScoreLabel(to newScore: Int) {            // Assignment 1. Adding score
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : self.theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "Score: \(newScore)", attributes: attributes)
        self.scoreLabel.attributedText = attributedString
    }
    
    private func updateNewGameButtonTextColor() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : self.theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "New Game", attributes: attributes)
        self.newGameButton.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    private func updateViewFromModel() {
        for index in self.cardButtons.indices {
            ///---- при обращению к массиву всегда нужно проверять на его границы
            /// ^^^ как обрабатывать случай с индексом, выходящим за границы?
            let button = self.cardButtons[index]
            let card = self.game.cards[index]
            
            ///---- подумай как превратить эти 7 строчек снизу в 2 через тернарный оператор, это на ДЗ
            ///^^^ получилось с ворнингом
            card.isFaceUp ? (button.setTitle(self.emoji(for: card), for: UIControlState.normal), button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                : (button.setTitle("", for: UIControlState.normal), button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : self.theme.cardBackColor)
        }
    }
    
    private func emoji(for card: Card) -> String {
        if self.emoji[card] == nil, self.emojiChoices.count > 0 {
            let randomStringIndex = self.emojiChoices.index(self.emojiChoices.startIndex, offsetBy: self.emojiChoices.count.arc4random)
            self.emoji[card] = String(self.emojiChoices.remove(at: randomStringIndex)) // remove chosen emojies to get rid of duplication
        }
        return emoji[card] ?? "?" // the same as commented out code
    }
    
    private func chooseRandomTheme() -> (emojis: String, backgroundColor: UIColor, cardBackColor: UIColor) {
        let randomTheme = Array(self.themes.keys).shuffled()[0]
        /// Избегаем использования force unwrap так как это потенциально приводит к багам
        if let randomThemeValue = self.themes[randomTheme] {
            return randomThemeValue
        } else {
            return self.theme
        }
    }
}

extension Int {
    // я б switch здесь заюзал
    var arc4random: Int {
        switch self {
        case 1...:
            return Int(arc4random_uniform(UInt32(self)))
        case ..<0:
            return -Int(arc4random_uniform(UInt32(self)))
        default:
            return 0
        }
    }
}

