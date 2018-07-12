//
//  GameView.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 23/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class GameView: UIView {

    var cardViews = [CardView]() {
        willSet { cardViews.forEach() { $0.removeFromSuperview() } }
        didSet { cardViews.forEach() { addSubview($0) }; setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(Cell.aspectRatio),
                        frame: bounds)
        grid.cellCount = cardViews.count
        
        cardViews.indices.forEach() {
            cardViews[$0].frame = grid[$0]!.insetBy(dx: Cell.spacing, dy: Cell.spacing)
        }
    }
    
    fileprivate struct Cell {
        static let aspectRatio: CGFloat = 2 / 3
        static let spacing: CGFloat  = 2.0
    }
}
