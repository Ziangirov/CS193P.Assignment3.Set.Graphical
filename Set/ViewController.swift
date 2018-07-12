//
//  ViewController.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Game()
    
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var setCountLabel: UILabel!
    @IBOutlet weak private var deckCountLabel: UILabel!
    @IBOutlet weak private var dealCardsButton: UIButton!
    
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeOnTable))
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(reShuffle))
            
            swipe.direction = .down
            gameView.addGestureRecognizer(swipe)
            gameView.addGestureRecognizer(rotation)
        }
    }

    @objc private func dealThreeOnTable() {
        game.dealThreeOnTable()
        updateView()
    }
    
    @objc private func reShuffle() {
        game.reShuffle()
        updateView()
    }
    
    @objc private func tapCard(_ sender: UITapGestureRecognizer) {
        guard let tappedCard = sender.view as? CardView else { return }
        switch sender.state {
        case .ended:
            game.chooseCard(at: gameView.cardViews.index(of: tappedCard)! )
            updateView()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        gameView.cardViews.removeAll()
        updateDealCardsButtonView()
        updateViewFromModel()
        updateLabels()
    }
    
    private func updateDealCardsButtonView() {
        if game.deckCount > 0 {
            dealCardsButton.isEnabled = true
        } else {
            dealCardsButton.isEnabled = false
        }
    }
    
    private func updateLabels() {
        deckCountLabel.text = "Deck: \(game.deckCount)"
        setCountLabel.text = "Sets: \(game.cardsSets.count)"
        scoreLabel.text = "Score: \(game.score)"
        
        if game.isEnd() {
            switch game.deckCount {
            case 0:
                scoreLabel.layer.borderWidth = Constants.borderWidth
                scoreLabel.layer.borderColor = UIColor.orange.cgColor
            default:
                dealCardsButton.layer.borderWidth = Constants.borderWidth
                dealCardsButton.layer.borderColor = UIColor.green.cgColor
            }
        } else {
            scoreLabel.layer.borderColor = UIColor.white.withAlphaComponent(0).cgColor
            dealCardsButton.layer.borderColor = UIColor.white.withAlphaComponent(0).cgColor
        }
    }
    
    private func updateViewFromModel() {
        for card in game.cardsOnTable {
            
            let cardView = CardView()
            cardView.card = card
    
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
            cardView.addGestureRecognizer(tap)
            
            gameView.cardViews.append(cardView)
            
            if game.cardsHints.contains(card) {
                cardView.state = .hinted
            }
            if game.cardsSelected.contains(card) {
                cardView.state = .selected
            }
            
            cardView.layoutSubviews()
        }
    }
}

private extension ViewController {
    struct Constants {
        static let borderWidth: CGFloat = 3.0
    }
}

//MARK: Actions
private extension ViewController {
    @IBAction func newGame(_ sender: UIButton) {
        game.reset()
        updateView()
    }
    
    @IBAction func hintButton(_ sender: UIButton) {
        game.hint()
        updateView()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        dealThreeOnTable()
    }
}
