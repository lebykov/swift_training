//
//  ViewController.swift
//  Concertration
//
//  Created by Быков Алексей on 24.03.2018.
//  Copyright © 2018 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards) // lazy means that variable is not initialized until someone grabs it. lazy cannot have a didSet(observable)
    
    var numberOfPairsOfCards: Int {    // no need to set private, if you want prop to be readable, but not writable because this is a computed prop is only gettable
            return (cardButtons.count + 1) / 2  // this is read only property, get{} is omitted
    }
    ///--- закоменченный код - зло
    // Moved to Concentration
//    private(set) var flipCount = 0 {
//        didSet {    // property observer called every time flip count changes
//            updateFlipCountLabel(to: game.)
//        }
//    }
    
    private func updateBackgroundColor() {
        self.view.backgroundColor = theme.backgroundColor
    }
    
    private func updateCardsBackColor() {
        for button in cardButtons {
            button.backgroundColor = theme.cardBackColor
        }
    }
    
    private func updateFlipCountLabel(to flipCount: Int) {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLable.attributedText = attributedString
    }
    
    private func updateScoreLabel(to newScore: Int) {            // Assignment 1. Adding score
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "Score: \(newScore)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    private func updateNewGameButtonTextColor() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : theme.cardBackColor
        ]
        let attributedString = NSAttributedString(string: "New Game", attributes: attributes)
        newGameButton.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    ///---- Комментарии и документация к коду обычно пишется на русском, зачем лишний раз переводить и задумываться
    // almost always Outlets must be private
    @IBOutlet private weak var flipCountLable: UILabel! {
        didSet {
//            updateFlipCountLabel(to: game.flipCount)
            updateFlipCountLabel(to: game.flipCount)
        }
    }
    

    @IBOutlet private weak var scoreLabel: UILabel! {      // Assignment 1. Adding score
        ///--  Так симпатичнее
        didSet { updateScoreLabel(to: game.score) }
    }
    
    @IBOutlet weak var newGameButton: UIButton! {
        didSet { updateNewGameButtonTextColor() }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!  // or Arrya<UIButton> like in Java
    
    // MARK: Handle Card Touch Behaviour
    
    @IBAction private func touchCard(_ sender: UIButton) {
//        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
//            print("cardNumber = \(cardNumber)")
//            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            updateFlipCountLabel(to: game.flipCount) // Assignment 1. Moving flipCount out of ViewController
            updateScoreLabel(to: game.score)    // Assignment 1. Adding score
            updateViewFromModel()
        } else {
          print("choosen card was not in cardButtons")
        }
    }
    
    
    // MARK: Assignment 1: New Game Button
    
    @IBAction func startNewGame(_ sender: UIButton) {
//        print("New Game Button pressed")
//        print("emijiChoices: \(emojiChoices)")
        
        ///---- Обращение к свойствам текущего класса или вызов методов - через self, так сразу понятно что это относится НЕ к локальным переменным
        self.game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
//        updateEmojiChoices(newEmojis: randomThemeEmojis())
        self.theme = chooseRandomTheme()
        self.emojiChoices = theme.emojis
        self.updateBackgroundColor()
        self.updateCardsBackColor()
        self.updateNewGameButtonTextColor()
        self.updateViewFromModel()
        self.updateScoreLabel(to: game.score)
        self.updateFlipCountLabel(to: game.flipCount)
    }
    ///---- где то две строки пустых, а где то одна - не единообразно
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            ///---- при обращению к массиву всегда нужно проверять на его границы
            let button = cardButtons[index]
            let card = game.cards[index]
            
           ///---- подумай как превратить эти 7 строчек снизу в 2 через тернарный оператор, это на ДЗ
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : theme.cardBackColor
            }
        }
    }
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
    private lazy var emojiChoices = theme.emojis
    ///---- Придерживаемся единого стиля
    private var emoji = [Card: String]() // initialization of Dictionary
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex)) // remove chosen emojies to get rid of duplication
        }
        
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
        
        return emoji[card] ?? "?" // the same as commented out code
    }
    
    private func chooseRandomTheme() -> (emojis: String, backgroundColor: UIColor, cardBackColor: UIColor) {
        let randomTheme = Array(themes.keys).shuffled()[0]
        /// Избегаем использования force unwrap так как это потенциально приводит к багам
        return themes[randomTheme]!
    }
}

extension Int {
    // я б switch здесь заюзал
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

