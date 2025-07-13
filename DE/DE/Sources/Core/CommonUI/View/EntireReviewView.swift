// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class EntireReviewView: UIView {
    
    private let title = TitleWithoutBarView(title: "전체 리뷰", subTitle: "")
    public let dropdownView = CustomDropdownView(options: ["최신 순", "오래된 순", "별점 높은 순", "별점 낮은 순"])
    
    public lazy var reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.estimatedItemSize = .zero
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: DynamicPadding.dynamicValue(20), right: 0)
    }).then {
        $0.layer.cornerRadius = 10
        $0.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, dropdownView, reviewCollectionView].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        dropdownView.snp.makeConstraints {
            $0.bottom.equalTo(title.snp.bottom).offset(-7)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.width.equalTo(90)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
