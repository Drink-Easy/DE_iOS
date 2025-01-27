// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 계열 선택 뷰
class OnlyScrollView: UIView {
    
    var layout = LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 12
    }
    
    public lazy var noseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.setCollectionViewLayout(layout, animated: true)
        $0.backgroundColor = .clear
        $0.tag = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addComponents() {
        [noseCollectionView].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        noseCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func updateNoseCollectionViewHeight() {
        noseCollectionView.layoutIfNeeded() // 레이아웃 업데이트
        let contentHeight = noseCollectionView.contentSize.height
        noseCollectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
    }
    
}
