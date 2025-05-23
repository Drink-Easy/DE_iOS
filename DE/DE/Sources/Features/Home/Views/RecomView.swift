// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import DesignSystem

class RecomView: UIView {
    
    public lazy var title = UILabel().then {
        $0.font = UIFont.pretendard(.semiBold, size: 22)
        $0.textColor = AppColor.black
    }
    
    public lazy var moreBtn = UIButton().then {
        
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        configuration.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal).withTintColor(AppColor.gray70)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular) // 원하는 크기
        configuration.preferredSymbolConfigurationForImage = symbolConfiguration
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 2
        
        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.pretendard(.regular, size: 12), .foregroundColor: AppColor.gray70])
        configuration.attributedTitle = AttributedString("더보기", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0)
        
        $0.configuration = configuration
        $0.backgroundColor = .clear
    }
    
    public lazy var recomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 12
        $0.scrollDirection = .horizontal
        $0.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }).then {
        $0.register(RecomCollectionViewCell.self, forCellWithReuseIdentifier: RecomCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, moreBtn, recomCollectionView].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(24.0))
        }
        
        moreBtn.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(22.0))
        }
        
        recomCollectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(247)
            $0.bottom.equalToSuperview()
        }
    }
}
