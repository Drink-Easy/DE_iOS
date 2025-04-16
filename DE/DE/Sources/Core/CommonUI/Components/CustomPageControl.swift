// Copyright © 2024 DRINKIG. All rights reserved

import DesignSystem
import UIKit

public class CustomPageControl: UIView {
    
    public init(indicatorColor: UIColor, currentIndicatorColor: UIColor) {
        super.init(frame: .zero)

        self.indicatorColor = indicatorColor
        self.currentIndicatorColor = currentIndicatorColor

        setupIndicators()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var numberOfPages: Int = 0 {
        didSet { setupIndicators() }
    }
    public var currentPage: Int = 0 {
        didSet { updateIndicators() }
    }
    
    public var indicatorColor: UIColor = .white
    public var currentIndicatorColor: UIColor = .white
    
    public var indicators: [UIView] = []

    public func setupIndicators() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators = []

        for _ in 0..<numberOfPages {
            let indicator = UIView()
            indicator.backgroundColor = indicatorColor
            indicator.layer.cornerRadius = 4
            addSubview(indicator)
            indicators.append(indicator)
        }
        setNeedsLayout()
    }

    public func updateIndicators() {
        for (index, indicator) in indicators.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut , animations: {
                if index == self.currentPage {
                    indicator.backgroundColor = self.currentIndicatorColor
                    indicator.frame.size = CGSize(width: 20, height: 8)
                    indicator.layer.cornerRadius = 4
                } else {
                    indicator.backgroundColor = self.indicatorColor
                    indicator.frame.size = CGSize(width: 8, height: 8)
                    indicator.layer.cornerRadius = 4
                }
            }, completion: nil)
        }
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        let spacing: CGFloat = 10
        let totalWidth = CGFloat(numberOfPages - 1) * (8 + spacing) + 20
        let startX = (bounds.width - totalWidth) / 2
        var xOffset = startX

        for (index, indicator) in indicators.enumerated() {
            indicator.frame.origin = CGPoint(x: xOffset, y: (bounds.height - indicator.frame.height) / 2)
            xOffset += (index == currentPage ? 20 : 8) + spacing
        }
    }
}
