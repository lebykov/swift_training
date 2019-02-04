//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Быков Алексей on 26/01/2019.
//  Copyright © 2019 abykov. All rights reserved.
//

import UIKit

@IBDesignable   // makes images appear in Interface Builder
class PlayingCardView: UIView {
    
    private var cornerString: NSAttributedString {
        return self.centeredAttributedString(self.rankString + "\n" + self.suit, fontSize: self.cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = self.createCornerLabel()
    private lazy var lowerRightCornerLabel = self.createCornerLabel()
    
    @IBInspectable // makes this prop visible in Inteface Builder
    var rank: Int = 11 { didSet { self.setNeedsDisplay(); self.setNeedsLayout() } }
    @IBInspectable
    var suit: String = "♥️" { didSet { self.setNeedsDisplay(); self.setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet { self.setNeedsDisplay(); self.setNeedsLayout() } }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet {self.setNeedsDisplay() } }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // use as many lines as you need
        self.addSubview(label)       // tell system to draw this label
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = self.cornerString
        label.frame.size = .zero  // because if width != 0 label won't
        label.sizeToFit()               // be sized to fit
        label.isHidden = !self.isFaceUp
    }
	
    private func drawPips() {
        let pipsPerRowForRank = [[0], [1], [1,1],
								 [1,1,1], [2,2], [2,1,2], [2,2,2],
								 [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        func createPipsString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            
            if maxVerticalPipCount.isZero { return NSAttributedString() }
            
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = self.centeredAttributedString(self.suit, fontSize: verticalPipRowSpacing)
            
            if attemptedPipString.size().height.isZero || verticalPipRowSpacing.isZero { return NSAttributedString() }
			
			///--- probablyOkay это как ? нейминг не очень
            let probablyOkayStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = self.centeredAttributedString(self.suit, fontSize: probablyOkayStringFontSize)
            
            if maxHorizontalPipCount.isZero
                || pipRect.size.width.isZero
                || probablyOkayPipString.size().width.isZero {
                return NSAttributedString() /// в таких кейсах лучше возращать nil, иначе не поймем снаружи что что-то не так
            }
            
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return self.centeredAttributedString(self.suit, fontSize: probablyOkayStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
		
        if pipsPerRowForRank.indices.contains(self.rank) {
            let pipsPerRow = pipsPerRowForRank[self.rank]
            var pipRect = self.bounds.insetBy(dx: self.cornerOffset, dy: self.cornerOffset).insetBy(dx: self.cornerString.size().width, dy: self.cornerString.size().height / 2)
            let pipString = createPipsString(thatFits: pipRect)
			
			///--- проверка на пустой массив лучше так pipsPerRow.isEmpty
            if CGFloat(pipsPerRow.count).isZero { return }
			
            let pipRowSpacing  = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1: pipString.draw(in: pipRect)
                case 2: pipString.draw(in: pipRect.leftHalf); pipString.draw(in: pipRect.rightHalf)
                default: break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    private func drawCardFace() {
        // Arguments "in:" and "compatibleWith:" makes images appear in Interface Builder
        if let faceCardImage = UIImage(named: self.rankString + self.suit,
									   in: Bundle(for: self.classForCoder),
									   compatibleWith: traitCollection) {
            faceCardImage.draw(in: bounds.zoom(by: self.faceCardScale))
        } else {
            self.drawPips()
        }
    }
    
    private func drawCardBack() {
        if let cardBackImage = UIImage(named: "cardback",
									   in: Bundle(for: self.classForCoder),
									   compatibleWith: traitCollection) {
            cardBackImage.draw(in: bounds)
        }
    }
    
    @objc func adjustFaceCardScale(byHandlingGesturerecognizerBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            self.faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        self.isFaceUp ? self.drawCardFace() : self.drawCardBack()
    }
    
    // triggers redraw of the view when size of the font in ios is changed
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() { // called by the system to layout subviews
        super.layoutSubviews()
        self.configureCornerLabel(self.upperLeftCornerLabel)
        self.upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: self.cornerOffset, dy: self.cornerOffset)
        
        self.configureCornerLabel(self.lowerRightCornerLabel)
        self.lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: self.lowerRightCornerLabel.frame.size.width, y: self.lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        self.lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -self.cornerOffset, dy: -self.cornerOffset)
            .offsetBy(dx: -self.lowerRightCornerLabel.frame.size.width, dy: -self.lowerRightCornerLabel.frame.size.height)
    }
}

extension PlayingCardView {
    // swift way to keep constants
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return self.cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch self.rank {
        case 1: return "A"
        case 2...10: return String(self.rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = self.width * scale
        let newHeight = self.height * scale
        return insetBy(dx: (self.width - newWidth) / 2, dy: (self.height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
