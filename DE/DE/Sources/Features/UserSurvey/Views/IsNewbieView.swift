// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

class IsNewbieView: UIView {
    
    private lazy var title = UILabel().then {
        $0.text = "드링키지에게 알려주세요!"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.textColor = AppColor.black
    }
    
    public lazy var isNewbieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 18
    }).then {
        $0.register(IsNewbieCollectionViewCell.self, forCellWithReuseIdentifier: IsNewbieCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = false
    }
    
    public lazy var startButton = CustomButton(
        title: "어울리는 와인 추천 받기",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgGray
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, isNewbieCollectionView, startButton].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            $0.leading.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(24.0))
        }
        
        isNewbieCollectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(DynamicPadding.dynamicValue(40.0))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(24.0))
            $0.height.equalTo(isNewbieCollectionView.snp.width).multipliedBy(218.0 / 342.0)
        }
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(28.0))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(42.0))
        }
    }
}
