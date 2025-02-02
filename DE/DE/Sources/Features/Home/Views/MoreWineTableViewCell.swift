// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import SDWebImage

class MoreWineTableViewCell: UITableViewCell {
    
    private let borderLayer = CALayer()
    
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = AppColor.winebg
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var name = UILabel().then {
        $0.textColor = Constants.AppColor.DGblack
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.lineBreakStrategy = .standard
    }
    
    private lazy var kind = UILabel().then {
        $0.textColor = AppColor.gray100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }
    
    private lazy var score = UILabel().then {
        $0.textColor = Constants.AppColor.purple100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }
    
    private lazy var price = UILabel().then {
        $0.textColor = Constants.AppColor.purple100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            borderLayer.cornerRadius = 8
            contentView.backgroundColor = Constants.AppColor.purple10 // 선택된 배경색
            borderLayer.borderColor = Constants.AppColor.purple70?.cgColor // 선택된 테두리색
            // 1초 후 기본 상태로 복원
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.contentView.backgroundColor = Constants.AppColor.grayBG // 기본 배경색
                self.borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
            }
        } else {
            contentView.backgroundColor = Constants.AppColor.grayBG // 기본 배경색
            borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addComponents()
        constraints()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
        self.name.text = nil
        self.kind.text = nil
        self.score.text = nil
        self.price.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 기본 셀 스타일 설정
        contentView.backgroundColor = Constants.AppColor.grayBG
        selectionStyle = .none // 기본 선택 스타일 제거
        
        // 테두리 설정
        borderLayer.borderWidth = 1
        borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        borderLayer.frame = contentView.bounds
        contentView.layer.addSublayer(borderLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = contentView.bounds // 레이아웃 변경 시 테두리 업데이트
    }
    
    private func addComponents() {
        [imageBackground, name, kind, score, price].forEach{ self.addSubview($0) }
        imageBackground.addSubview(image)
    }
    
    private func constraints() {
        
        imageBackground.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().offset(6)
            $0.width.height.equalTo(88)
        }
        
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        name.snp.makeConstraints {
            $0.leading.equalTo(imageBackground.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(6)
            $0.top.equalTo(imageBackground.snp.top)
        }
        
        kind.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(3)
            $0.leading.equalTo(name.snp.leading)
        }
        
        score.snp.makeConstraints {
            $0.leading.equalTo(kind.snp.leading)
            $0.bottom.equalTo(imageBackground.snp.bottom)
        }
        
        price.snp.makeConstraints {
            $0.leading.equalTo(score.snp.trailing).offset(10)
            $0.bottom.equalTo(score.snp.bottom)
        }
    }
    
    public func configure(model: WineData) {
        if let url = URL(string: model.imageUrl) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        name.text = model.wineName
        kind.text = "와인 > \(model.sort)"
        score.text = "★ \(String(format: "%.1f", model.vivinoRating))"
        price.text = model.price == 0 ? "가격 정보 없음" : "₩ \(model.price / 10000)만원 대"
    }

}
