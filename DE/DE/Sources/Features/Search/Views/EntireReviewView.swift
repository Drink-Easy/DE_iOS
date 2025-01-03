// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class EntireReviewView: UIView {
    
    private let title = TitleWithBarView(title: "리뷰 전체보기", subTitle: "")
    public let dropdownView = CustomDropdownView(options: ["최신순", "별점순"])
    
    public lazy var reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
    }).then {
        $0.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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
        }
        
        dropdownView.snp.makeConstraints {
            $0.bottom.equalTo(title.snp.bottom).offset(-7)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-25)
            $0.width.equalTo(65)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(37)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
