// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem

class MyWineTableViewCell: UITableViewCell {
    
    static let identifier = "MyWineTableViewCell"
    
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = AppColor.wineBackground
    }
    
    private lazy var image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private lazy var name = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.semiBold, size: 16)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.lineBreakStrategy = .standard
    }
    
    private lazy var price = UILabel().then {
        $0.textColor = AppColor.gray100
        $0.font = UIFont.pretendard(.regular, size: 14)
    }
    
    private lazy var buyDate = UILabel().then {
        $0.textColor = AppColor.purple100
        $0.font = UIFont.pretendard(.regular, size: 14)
        $0.textAlignment = .right
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        self.price.text = nil
        self.buyDate.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 기본 셀 스타일 설정
        contentView.backgroundColor = AppColor.background
        selectionStyle = .none // 기본 선택 스타일 제거
    }
    
    private func addComponents() {
        [imageBackground, name, price, buyDate].forEach{ self.addSubview($0) }
        imageBackground.addSubview(image)
    }
    
    private func constraints() {
        
        imageBackground.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(6)
            $0.width.height.equalTo(70)
        }
        
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        buyDate.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-6)
            $0.top.equalTo(name.snp.top)
            $0.width.equalTo(Constants.superViewWidth * 0.15)
        }
        
        name.snp.makeConstraints {
            $0.leading.equalTo(imageBackground.snp.trailing).offset(18)
            $0.top.equalTo(imageBackground.snp.top)
            $0.trailing.lessThanOrEqualTo(buyDate.snp.leading).offset(-4)
            $0.width.equalTo(Constants.superViewWidth * 0.56)
        }
        
        price.snp.makeConstraints {
            $0.leading.equalTo(name.snp.leading)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    public func configure(model: MyWineViewModel) {
        if let url = URL(string: model.wineImageUrl) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        
        if let vintage = model.vintage {
            /// 빈티지 있는 경우에는 이름에 빈티지도 함께 표시
            self.name.text = "\(model.wineName) \(vintage)"
        } else {
            self.name.text = model.wineName
        }
        
        let priceString = formatPrice(model.purchasePrice)
        
        self.price.text = "구매가 \(priceString)원"
        
        if model.period >= 0 {
            self.buyDate.text = "D+\(model.period + 1)"
        } else {
            self.buyDate.text = "D\(model.period)"
        }
    }
}

public func formatPrice(_ price: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: "ko_KR")
    
    return numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
}
