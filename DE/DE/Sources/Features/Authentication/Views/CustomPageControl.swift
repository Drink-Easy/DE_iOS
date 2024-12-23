// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import CoreModule

class CustomPageControl: UIView {
    var numberOfPages: Int = 0 {
        didSet { setupIndicators() }
    }
    var currentPage: Int = 0 {
        didSet { updateIndicators() }
    }
    var indicatorColor: UIColor = .white
    var currentIndicatorColor: UIColor = .white
    
    private var indicators: [UIView] = []

    private func setupIndicators() {
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

    private func updateIndicators() {
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
    
    override func layoutSubviews() {
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
