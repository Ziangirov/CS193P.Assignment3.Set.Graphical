//
//  Game.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

struct Game {
    
    private var deck = CardDeck()
    var deckCount: Int { return deck.cards.count }
    
    private(set) var score = 0
    
    private(set) var cardsOnTable = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var cardsSets = [[Card]]()
    
    private(set) lazy var cardsHints = [Card]()
    
    private var isSet: Bool? {
        get {
            guard cardsSelected.count == CardsCountFor.set else { return nil }
            return cardsSelected.isSet()
        }
        set {
            if newValue != nil {
                switch newValue! {
                case true:
                    cardsSets.append(cardsSelected)
                    replaceOrRemoveCard()
                    score += Score.bonus.rawValue
                case false:
                    score += Score.penalty.rawValue
                }
            }
            cardsSelected.removeAll()
        }
    }

    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        let chosenCard = cardsOnTable[index]
        
        switch cardsSelected {
        case let cardsForSet where cardsForSet.count == CardsCountFor.set: isSet = isSet
        case let cardsForSet where !cardsForSet.contains(chosenCard): cardsSelected.append(chosenCard)
        default:
            cardsSelected = cardsSelected.filter() { $0 != chosenCard }
        }
    }

    private mutating func replaceOrRemoveCard() {
        for cardSelected in cardsSelected {
            let indexForChange = cardsOnTable.index(of: cardSelected)
            
            if cardsOnTable.count <= CardsCountFor.start, let card = deck.deal() {
                cardsOnTable[indexForChange!] = card
            } else {
                cardsOnTable.remove(at: indexForChange!)
            }
        }
    }
    
    mutating func hint() {
        cardsSelected.removeAll()
        score += Score.hint.rawValue
        cardsHints = cardsOnTable.thripletFor() { $0.isSet() }
    }
    
    mutating func reShuffle() {
        cardsOnTable.shuffle()
    }
    
    mutating func dealThreeOnTable() {
        repeatBy(CardsCountFor.deal) { deal() }
    }
    
    mutating func isEnd() -> Bool {
        return cardsOnTable.thripletFor() { $0.isSet() }.isEmpty
    }
    
    mutating func reset() {
        self = Game()
    }
    
    init() {
        repeatBy(CardsCountFor.start) { deal() }
    }
}

private extension Game {
    struct CardsCountFor {
        static let start = 12
        static let deal = 3
        static let set = 3
    }
    
    enum Score: Int {
        case bonus = 3, penalty = -5, hint = -2
    }
    
    mutating func deal() {
        if let card = deck.deal() {
            cardsOnTable.append(card)
        }
    }
    
    func repeatBy(_ repeatingCount: Int, foo: ()->()) {
        guard repeatingCount > 0 else { return }
        for _ in 1...repeatingCount { foo() }
    }
}

private extension Array where Element == Card {
    func isSet() -> Bool {
        let validValues = Set([1, 3])
        
        let number  = Set(self.map { $0.number } )
        let symbol  = Set(self.map { $0.symbol } )
        let color   = Set(self.map { $0.color } )
        let shade   = Set(self.map { $0.shade } )
        
        return  validValues.contains(number.count) &&
                validValues.contains(symbol.count) &&
                validValues.contains(color.count) &&
                validValues.contains(shade.count)
    }
}

private extension Array where Element: Equatable {
    func thripletFor(_ closure: (_ check: [Element]) -> (Bool)) -> [Element] {
        if self.count >= 3 {
            for i in 0..<self.count {
                for j in (i + 1)..<self.count {
                    for k in (j + 1)..<self.count {
                        let result = [self[i], self[j], self[k]]
                        if closure(result) {
                            return result
                        }
                    }
                }
            }
        }
        return []
    }
}
