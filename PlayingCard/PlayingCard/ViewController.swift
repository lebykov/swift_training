//
//  ViewController.swift
//  PlayingCard
//
//  Created by Быков Алексей on 26/01/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.nextCard))
            swipe.direction = [.left, .right]
            self.playingCardView.addGestureRecognizer(swipe)
            let pinch = UIPinchGestureRecognizer(target: self.playingCardView, action: #selector(self.playingCardView.adjustFaceCardScale(byHandlingGesturerecognizerBy:)))
            self.playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.playingCardView.isFaceUp = !self.playingCardView.isFaceUp
        default: break
        }
    }
    
    @objc func nextCard() {
        if let card = self.deck.draw() {
            self.playingCardView.rank = card.rank.order
            self.playingCardView.suit = card.suit.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

