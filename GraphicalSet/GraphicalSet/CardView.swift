//
//  CardView.swift
//  GraphicalSet
//
//  Created by Быков Алексей on 17/02/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var number: Int = 3
    var symbol: Int = 3
    var shading: Int = 1
    var color: Int = 2
    
    private struct CardViewConstants {
        static let paddingCoefficient: CGFloat = 0.05
    }
    
    lazy var symbolRectSideLenght: CGFloat = [self.bounds.width, self.bounds.height / 3].min() ?? 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.lightGray
    }
    
    override func draw(_ rect: CGRect) {
        for positions in self.calculateSymbolsPositions() {
            self.drawSymbol(in: positions)
        }
    }
    
    private func drawDiamond(in rect: CGRect) {
        let diamondPath = UIBezierPath()
        diamondPath.move(to: CGPoint(x: rect.midX - rect.size.width / 2, y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY - rect.size.height * 0.25))
        diamondPath.addLine(to: CGPoint(x: rect.midX + rect.size.width / 2, y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.size.height * 0.25))
        diamondPath.close()

        self.getSymbolColor().setFill()
        diamondPath.fill()
    }
    
    private func drawOval(in rect: CGRect) {
        let ovalPath = UIBezierPath()
        ovalPath.move(to: CGPoint(x: rect.midX - rect.size.width * 0.25,
                                  y: rect.midY - rect.size.height * 0.25))
        ovalPath.addLine(to: CGPoint(x: rect.midX + rect.size.width * 0.25,
                                     y: rect.midY - rect.size.height * 0.25))
        ovalPath.addArc(withCenter: CGPoint(x: rect.midX + rect.size.width * 0.25,
                                            y: rect.midY),
                        radius: rect.size.height * 0.25,
                        startAngle: CGFloat.pi * 1.5,
                        endAngle: CGFloat.pi / 2,
                        clockwise: true)
        ovalPath.addLine(to: CGPoint(x: rect.midX - rect.size.width * 0.25,
                                     y: rect.midY + rect.size.height * 0.25))
        ovalPath.addArc(withCenter: CGPoint(x: rect.midX - rect.size.width * 0.25,
                                            y: rect.midY),
                        radius: rect.size.height * 0.25,
                        startAngle: CGFloat.pi / 2,
                        endAngle: CGFloat.pi * 1.5,
                        clockwise: true)
        ovalPath.close()
        self.getSymbolColor().setFill()
        ovalPath.fill()
    }
    
    private func drawTriangle(in rect: CGRect) {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y))
        trianglePath.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
        trianglePath.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height))
        trianglePath.close()
        
        self.getSymbolColor().setFill()
        trianglePath.fill()
    }
    
    private func drawSymbol(in rect: CGRect) {
        switch self.symbol {
        case 1:
            self.drawTriangle(in: rect)
        case 2:
            self.drawOval(in: rect)
        case 3:
            self.drawDiamond(in: rect)
        default:
            print("How to handle this case?")
        }
    }
    
    private func calculateSymbolsPositions() -> [CGRect] {
        var positions: [CGRect] = []
        for position in 0..<self.number {
            let posX = self.bounds.midX - self.symbolRectSideLenght / 2
            let posY = self.bounds.midY - self.symbolRectSideLenght * 0.5 * CGFloat(self.number) + self.symbolRectSideLenght * CGFloat(position)
            positions.append(
                CGRect(
                    origin: CGPoint(x: posX, y: posY),
                    size: CGSize(width: self.symbolRectSideLenght, height: self.symbolRectSideLenght)
                    ).insetBy(dx: self.symbolRectSideLenght * CardViewConstants.paddingCoefficient,
                              dy: self.symbolRectSideLenght * CardViewConstants.paddingCoefficient)
            )
        }
        return positions
    }
    
    private func getSymbolColor() -> (UIColor) {
        switch self.color {
        case 1:
            return UIColor.green
        case 2:
            return UIColor.red
        case 3:
            return UIColor.blue
        default:
            return UIColor.magenta
        }
    }
}
