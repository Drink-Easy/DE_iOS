// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import SnapKit
import CoreModule
import SDWebImage

class RecomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecomCollectionViewCell"
    
    public lazy var image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.sd_imageIndicator = SDWebImageActivityIndicator.gray // 로딩 인디케이터 추가
        $0.clipsToBounds = true
    }
    
    public lazy var scoreNprice = UILabel().then {
        $0.textColor = AppColor.purple100
        $0.font = UIFont.ptdMediumFont(ofSize: 12)
    }
    
    public lazy var name = UILabel().then {
        $0.text = "부와젤, 조아유 드 프랑스"
        $0.textColor = .black
        $0.font = UIFont.ptdMediumFont(ofSize: 14)
    }
    
    public lazy var kind = UILabel().then {
        $0.text = "스파클링 와인, 샴페인"
        $0.textColor = AppColor.gray70
        $0.font = UIFont.ptdRegularFont(ofSize: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addComponents()
        constraints()
        configureShadow()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureShadow() {
        self.layer.shadowColor = UIColor(hex: "#9876A9")?.cgColor // 그림자 색상
        self.layer.shadowOpacity = 0.2 // 그림자 투명도 (0.0 ~ 1.0)
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자의 위치 (x, y)
        self.layer.shadowRadius = 4 // 그림자 흐림 정도
        self.layer.masksToBounds = false // 그림자가 보이도록 설정
    }
    
    private func addComponents() {
        [image, scoreNprice, name, kind].forEach{ contentView.addSubview($0) }
    }
    
    private func constraints() {
        
        scoreNprice.snp.makeConstraints {
            $0.top.equalToSuperview().offset(144)
            $0.leading.equalToSuperview().offset(12)
        }
        
        image.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalTo(scoreNprice.snp.top).offset(-5)
            $0.centerX.equalToSuperview()
        }
        
        name.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.top.equalTo(scoreNprice.snp.bottom).offset(6)
        }
        
        kind.snp.makeConstraints {
            $0.leading.equalTo(name.snp.leading)
            $0.top.equalTo(name.snp.bottom).offset(3)
        }
    }
    
    func configure(imageURL: String, score: String, price: String, name: String, kind: String) {
        // SDWebImage를 이용한 이미지 로딩
        image.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder")) // 로딩 중에는 placeholder 표시
        
        // 데이터 설정
        scoreNprice.text = "★ \(score)  |  \(price)만원 대"
        self.name.text = name
        self.kind.text = kind
    }
}
