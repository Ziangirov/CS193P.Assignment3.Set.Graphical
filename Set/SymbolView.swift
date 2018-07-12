//
//  SymbolView.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 23/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class SymbolView: UIView {
    
    private var symbol: Card.Symbol?
    private var color: Card.Color?
    private var shade: Card.Shade?

    override func draw(_ rect: CGRect) {
        let path: UIBezierPath = { [weak self] in
            switch self?.symbol {
            case nil: return UIBezierPath()
            case .circle?:
                return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                    radius: bounds.height / 2,
                                    startAngle: 0,
                                    endAngle: CGFloat.pi * 2,
                                    clockwise: true)
            case .square?:
                return UIBezierPath(rect: CGRect(x: bounds.origin.x,
                                                 y: bounds.origin.y,
                                                 width: bounds.width,
                                                 height: bounds.height))
            case .triangle?:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.width / 2,
                                      y: bounds.origin.y))
                path.addLine(to: CGPoint(x: bounds.origin.x,
                                         y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width,
                                         y: bounds.height))
                path.close()
                return path
            }
        }()

        path.addClip()
        
        let color: UIColor = { [weak self] in
            switch self?.color {
            case nil: return UIColor.red.withAlphaComponent(1)
            case .red?: return UIColor.red
            case .green?: return UIColor.green
            case .purple?: return UIColor.purple
            }
        }()
        
        color.setStroke()
        color.setFill()
        
        if let shade = shade {
            switch shade {
            case .filled:
                path.fill()
            case .striped:
                for x in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.lineWidth = Constants.lineWidthStriped
                    path.stroke()
                }
                for y in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: y, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: y))
                    path.lineWidth = Constants.lineWidthStriped
                    path.stroke()
                }
                fallthrough
            case .outlined:
                path.lineWidth = Constants.lineWidthOutlined
                path.stroke()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(symbol: Card.Symbol, color: Card.Color, shade: Card.Shade) {
        self.init(frame: CGRect(origin: Constants.frameOrigin, size: Constants.frameSize))
        self.symbol = symbol
        self.color = color
        self.shade = shade
    }
    
    fileprivate struct Constants {
        static let frameOrigin = CGPoint(x: 0.0, y: 0.0)
        static let frameSize = CGSize(width: 100.0, height: 100.0)
        static let lineWidthStriped: CGFloat = 3.0
        static let lineWidthOutlined: CGFloat = 10.0
    }
}
