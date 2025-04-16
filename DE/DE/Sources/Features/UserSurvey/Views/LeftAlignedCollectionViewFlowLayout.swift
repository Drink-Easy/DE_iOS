// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import DesignSystem

//좌측 정렬이 가능한 UICollectionViewFlowLayout, 첫째줄과 셋째줄부터는 3개, 둘째줄에는 너비 넉넉하면 4개의 cell 들어감
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var leftMargin: CGFloat = sectionInset.left
        var lastY: CGFloat = -1
        var currentItemCount = 0
        var currentRowItemCount = 3  // 첫 줄 3개 고정
        var secondRowItemCount: Int? = nil  // 두 번째 줄 고정값 저장
        
        // 첫 번째 & 두 번째 줄 (줄바꿈 중복 방지)
        for (index, layoutAttribute) in attributes.enumerated() where index < 7 {
            if layoutAttribute.representedElementCategory == .cell {
                
                // 첫 번째 줄 3개 고정
                if index < 3 {
                    currentRowItemCount = 3
                }

                // 두 번째 줄 너비 검사 (한 번만 실행)
                if index == 3 {
                    let availableWidth = rect.width - sectionInset.left - sectionInset.right
                    let totalWidth = attributes[0...2].reduce(0) { $0 + $1.frame.width } + (minimumInteritemSpacing * 2)
                    
                    secondRowItemCount = (totalWidth + layoutAttribute.frame.width + minimumInteritemSpacing <= availableWidth) ? 4 : 3
                    currentRowItemCount = secondRowItemCount!
                    
                    // 두 번째 줄 시작 위치 (lastY 갱신)
                    leftMargin = sectionInset.left
                    lastY = attributes[2].frame.maxY + minimumLineSpacing
                    currentItemCount = 0
                }

                // 셀 위치 적용
                layoutAttribute.frame.origin.x = leftMargin
                layoutAttribute.frame.origin.y = lastY
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                currentItemCount += 1

                // 줄바꿈 체크
                if currentItemCount == currentRowItemCount {
                    leftMargin = sectionInset.left
                    lastY += layoutAttribute.frame.height + minimumLineSpacing
                    currentItemCount = 0
                }
            }
        }

        // 두 번째 for문 진입 전에 lastY 갱신 제거! -> 한 줄 띄움 방지
        leftMargin = sectionInset.left
        currentItemCount = 0
        currentRowItemCount = 3
        
        // 세 번째 줄 이후 (항상 3개 고정)
        for (index, layoutAttribute) in attributes.enumerated() where index >= 7 || (secondRowItemCount == 3 && index == 6) {
            if layoutAttribute.representedElementCategory == .cell {
                
                // 현재 줄이 가득 찼을 경우, 다음 줄로 이동
                if currentItemCount == currentRowItemCount {
                    leftMargin = sectionInset.left
                    lastY += layoutAttribute.frame.height + minimumLineSpacing
                    currentItemCount = 0
                }
                
                // 셀 위치 적용
                layoutAttribute.frame.origin.x = leftMargin
                layoutAttribute.frame.origin.y = lastY
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                currentItemCount += 1
            }
        }
        return attributes
    }
}
