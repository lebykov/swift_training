//
//  ViewController.swift
//  PlayingCard
//
//  Created by Быков Алексей on 26/01/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var deck = PlayingCardDeck()
        
        for card in deck.cards {
            print(card)
        }
		deck.cards.forEach { print($0) }
    }


}

