// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 계열 선택 뷰
class NoseBottomView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var layout = NewLeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 12
    }
    
    public lazy var noseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.setCollectionViewLayout(layout, animated: true)
        $0.backgroundColor = .clear
        $0.tag = 0
    }
    
    lazy var nextButton = CustomButton(title: "다음", isEnabled: false)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addComponents() {
        contentView.addSubview(noseCollectionView)
        contentView.addSubview(nextButton)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(nextButton.snp.bottom).offset(40) // 콘텐츠 끝까지 확장
        }
        
        noseCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(320) // 초기 높이
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(noseCollectionView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

    }
    
    func updateNoseCollectionViewHeight() {
        noseCollectionView.layoutIfNeeded() // 레이아웃 업데이트
        let contentHeight = noseCollectionView.contentSize.height
        print("Content Height: \(contentHeight)") // 디버깅 출력
        print("button height: \(nextButton.layer.frame.height)")
        noseCollectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
        contentView.snp.updateConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
        print("ScrollView Content Size: \(scrollView.contentSize)") // 스크롤뷰 크기 디버깅
    }
    
}
