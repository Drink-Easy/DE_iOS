// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then

class ReviewView: UIView {
    
    public var score = 4.0
    
    private let title = TitleWithBarView(title: "Review", subTitle: "리뷰")
    
    public lazy var scoreLabel = UILabel().then {
        let text = "\(score) / 5.0"
        $0.text = text
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes(
            [
                .foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0.6, alpha: 1.0),
                .font: UIFont.ptdRegularFont(ofSize: 12)
            ],
            range: NSRange(location: 0, length: text.count)
        )
        
        if let range = text.range(of: "\(score)") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttributes(
                [
                    .foregroundColor: Constants.AppColor.purple100 ?? .purple,
                    .font: UIFont.ptdSemiBoldFont(ofSize: 18)
                ],
                range: nsRange
            )
        }
        $0.attributedText = attributedString
    }
    
    public lazy var moreBtn = UIButton().then {
        
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        configuration.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.AppColor.gray60 ?? .gray)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular) // 원하는 크기
        configuration.preferredSymbolConfigurationForImage = symbolConfiguration
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 2

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.ptdMediumFont(ofSize: 12), .foregroundColor: Constants.AppColor.gray60 ?? .gray])
        configuration.attributedTitle = AttributedString("더보기", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0)

        $0.configuration = configuration
        $0.backgroundColor = .clear
    }
    
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
        backgroundColor = Constants.AppColor.grayBG
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, moreBtn, reviewCollectionView].forEach{ self.addSubview($0) }
        title.addSubview(scoreLabel)
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        moreBtn.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(25)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-24)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(moreBtn.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
