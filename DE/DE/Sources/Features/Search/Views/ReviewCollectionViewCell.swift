// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then

class ReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCollectionViewCell"
    
    public lazy var nickname = UILabel().then {
        //$0.text = "eoiwod"
        $0.textColor = .black
        $0.font = UIFont.ptdMediumFont(ofSize: 16)
    }
    
    public lazy var score = UILabel().then {
        //$0.text = "★ 4.0"
        $0.textColor = Constants.AppColor.purple100
        $0.font = UIFont.ptdMediumFont(ofSize: 14)
    }
    
    public lazy var review = UILabel().then {
        //$0.text = "가볍게 즐길 수 있는 와인이에요. 추천합니다."
        $0.numberOfLines = 0
        $0.textColor = Constants.AppColor.gray80
        $0.font = UIFont.ptdMediumFont(ofSize: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.94, alpha: 1.0)
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [nickname, score, review].forEach { contentView.addSubview($0) }
    }
    
    private func constraints() {
        nickname.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(18)
        }
        
        score.snp.makeConstraints {
            $0.centerY.equalTo(nickname)
            $0.leading.equalTo(nickname.snp.trailing).offset(8)
        }
        
        review.snp.makeConstraints {
            $0.leading.equalTo(nickname.snp.leading)
            $0.top.equalTo(nickname.snp.bottom).offset(4)
        }
    }
    
    public func configure(model: WineReviewModel) {
        nickname.text = model.name
        score.text = "★ \(String(model.rating))"
        review.text = model.contents
    }
}
