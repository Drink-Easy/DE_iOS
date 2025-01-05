// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

/// 좌측 정렬이 가능한 UICollectionViewFlowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin: CGFloat = 0
        var lastY: CGFloat = -1
        
        for layoutAttribute in attributes {
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y != lastY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                lastY = layoutAttribute.frame.origin.y
            }
        }
        return attributes
    }
}
