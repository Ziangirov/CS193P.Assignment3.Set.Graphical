//
//  CardView.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 22/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var card: Card? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var state: SelectionState = .unselected { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private var symbolViews = [SymbolView]() {
        willSet { symbolViews.forEach() { $0.removeFromSuperview() } }
        didSet { symbolViews.forEach() { addSubview($0) }; setNeedsLayout() }
    }
    
    private var boarderColor: UIColor {
        switch state {
        case .hinted: return Colors.hinted
        case .selected: return Colors.selected
        case .unselected: return Colors.filled
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let symbolSize = CGSize(width: bounds.size.height / 4, height: bounds.size.height / 4)
        let spaceBetweenSymbols = symbolSize.height / 4
        
        symbolViews.indices.forEach {
            
            symbolViews[$0].frame.size = symbolSize
            symbolViews[$0].frame.origin.x = bounds.midX - symbolSize.height / 2
            
            switch card?.number {
            case nil: break
            case .one?:
                symbolViews[0].frame.origin.y = bounds.midY - symbolSize.height / 2
            case .two?:
                symbolViews[0].frame.origin.y = bounds.midY - symbolSize.height - spaceBetweenSymbols
                symbolViews[1].frame.origin.y = bounds.midY + spaceBetweenSymbols
            case .three?:
                symbolViews[0].frame.origin.y = bounds.midY - symbolSize.height * 2 + spaceBetweenSymbols
                symbolViews[1].frame.origin.y = bounds.midY - symbolSize.height / 2
                symbolViews[2].frame.origin.y = bounds.midY + symbolSize.height - spaceBetweenSymbols
            }
        }
    }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        
        roundedRect.lineWidth = lineWidth
        boarderColor.setStroke()
        Colors.filled.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        
        if let card = card {
            for _ in 1...card.number.rawValue {
                let symbol = SymbolView(symbol: card.symbol, color: card.color, shade: card.shade)
                symbolViews.append(symbol)
            }
        }
    }
}

extension CardView {
    fileprivate struct Constants {
        static let sizeRatioToBounds: CGFloat = 0.005
        static let cornerRadius: CGFloat = 16.0
        static let lineWidth: CGFloat = 12.0
    }
    
    fileprivate var cornerRadius: CGFloat {
        return bounds.size.height * Constants.sizeRatioToBounds * Constants.cornerRadius
    }
    
    fileprivate var lineWidth: CGFloat {
        return bounds.size.height * Constants.sizeRatioToBounds * Constants.lineWidth
    }
    
    fileprivate struct Colors {
        static let filled = #colorLiteral(red: 0.9882352941, green: 0.9098039216, blue: 0.5725490196, alpha: 1)
        static let hinted = UIColor.cyan
        static let selected = UIColor.orange
    }
    
    enum SelectionState {
        case hinted
        case selected
        case unselected
    }
}
