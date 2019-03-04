//
//  CardView.swift
//  GraphicalSet
//
//  Created by Быков Алексей on 17/02/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var number: Int = 2 { didSet { self.setNeedsDisplay() } }
    var symbol: Int = 2 { didSet { self.setNeedsDisplay() } }
    var shading: Int = 3 { didSet { self.setNeedsDisplay() } }
    var color: Int = 1 { didSet { self.setNeedsDisplay() } }
    
    private struct CardViewConstants {  // private между public-ами
        static let paddingCoefficient: CGFloat = 0.05
        static let shadingNumberOfLines: Int = 30
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
    
    override func draw(_ rect: CGRect) {   // internal между private-ами
        for position in self.calculateSymbolsPositions() {
            let symbolPath = self.drawSymbol(in: position)
            self.setShading(for: symbolPath, in: position)
        }
    }
    
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let diamondPath = UIBezierPath()
        diamondPath.move(to: CGPoint(x: rect.midX - rect.size.width / 2,
                                     y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX,
                                        y: rect.midY - rect.size.height * 0.25))
        diamondPath.addLine(to: CGPoint(x: rect.midX + rect.size.width / 2,
                                        y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX,
                                        y: rect.midY + rect.size.height * 0.25))
        diamondPath.close()
        return diamondPath
    }
    
    private func drawOval(in rect: CGRect) -> UIBezierPath {
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
        return ovalPath
    }
    
    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        let squigglePath = UIBezierPath()
        squigglePath.move(to: CGPoint(x: rect.midX - rect.size.width * 0.4,
                                      y: rect.midY - rect.size.height * 0.25))
        squigglePath.addCurve(to: CGPoint(x: rect.midX + rect.size.width * 0.4,
                                          y: rect.midY - rect.size.height * 0.25),
                              controlPoint1: CGPoint(x: rect.midX + rect.size.width * 0.15,
                                                     y: rect.midY - rect.size.height * 0.5),
                              controlPoint2: CGPoint(x: rect.midX - rect.size.width * 0.15,
                                                     y: rect.midY))
        squigglePath.addQuadCurve(to: CGPoint(x: rect.midX + rect.size.width * 0.4,
                                              y: rect.midY + rect.size.height * 0.25),
                                  controlPoint: CGPoint(x: rect.midX + rect.size.width * 0.7,
                                                        y: rect.midY - rect.size.height * 0.25))
        squigglePath.addCurve(to: CGPoint(x: rect.midX - rect.size.width * 0.4,
                                          y: rect.midY + rect.size.height * 0.25),
                              controlPoint1: CGPoint(x: rect.midX - rect.size.width * 0.15,
                                                     y: rect.midY + rect.size.height * 0.5),
                              controlPoint2: CGPoint(x: rect.midX + rect.size.width * 0.15,
                                                     y: rect.midY))
        squigglePath.addQuadCurve(to: CGPoint(x: rect.midX - rect.size.width * 0.4,
                                              y: rect.midY - rect.size.height * 0.25),
                                  controlPoint: CGPoint(x: rect.midX - rect.size.width * 0.7,
                                                        y: rect.midY + rect.size.height * 0.25))
        squigglePath.close()
        return squigglePath
    }
    
    private func drawSymbol(in rect: CGRect) -> UIBezierPath {
        switch self.symbol {
        case 1: // не совсем понятно откуда такая зависимость между цифрами и фигурами
            return self.drawSquiggle(in: rect)
        case 2:
            return self.drawOval(in: rect)
        case 3:
            return self.drawDiamond(in: rect)
        default:
            return UIBezierPath()
        }
    }
    
    private func setShading(for symbol: UIBezierPath, in rect: CGRect) {
        switch self.shading {
        case 1:
            self.getSymbolColor().setStroke()
            symbol.lineWidth = self.symbolRectSideLenght * 0.03
            symbol.stroke()
        case 2:
            self.getSymbolColor().setFill()
            symbol.fill()
        case 3:
            if let context = UIGraphicsGetCurrentContext() { // лучше вынести в отдельную функцию
                context.saveGState()
                self.getSymbolColor().setStroke()
                symbol.lineWidth = self.symbolRectSideLenght * 0.03
                symbol.stroke()
                symbol.addClip()
                
                let shadingPath = UIBezierPath()
                let shadingDelta = symbolRectSideLenght.rounded(.down) / CGFloat(CardViewConstants.shadingNumberOfLines) // проверка на ноль
                for lineNumber in 0..<CardViewConstants.shadingNumberOfLines {
                    shadingPath.move(to: CGPoint(x: rect.origin.x,
                                                 y: rect.origin.y + shadingDelta * CGFloat(lineNumber)))
                    shadingPath.addLine(to: CGPoint(x: rect.origin.x + rect.size.width,
                                                    y: rect.origin.y + shadingDelta * CGFloat(lineNumber)))
                }
                shadingPath.lineWidth = self.symbolRectSideLenght * 0.01
                shadingPath.stroke()
                context.restoreGState()
            } else {
                print("UIGraphicsGetCurrentContext() returned nil")
            }
        default:
            print("Unknown shading case")
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
    
    private func getSymbolColor() -> UIColor {
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
