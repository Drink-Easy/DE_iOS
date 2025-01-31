// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 계열 선택 뷰
class NoseBottomView: UIView {
    
    var layout = NewLeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 12
    }
    
    public lazy var noseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.setCollectionViewLayout(layout, animated: true)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.tag = 0
    }
    
    lazy var nextButton = CustomButton(title: "다음", isEnabled: true) // TODO: 설정해야함

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addComponents() {
        addSubview(noseCollectionView)
        addSubview(nextButton)
    }
    
    private func setConstraints() {
        
        noseCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(530) // 초기 높이
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(noseCollectionView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
    }
    
//    func updateNoseCollectionViewHeight() {
//        noseCollectionView.layoutIfNeeded() // 레이아웃 업데이트
//        let contentHeight = noseCollectionView.contentSize.height
//        noseCollectionView.snp.updateConstraints { make in
//            make.height.equalTo(contentHeight)
//        }
//    }
}
