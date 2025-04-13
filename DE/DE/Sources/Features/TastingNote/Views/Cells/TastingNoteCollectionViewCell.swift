// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class TastingNoteCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.backgroundColor = AppColor.wineBackground
    }
    
    private lazy var image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var name = UILabel().then { l in
        l.font = UIFont.pretendard(.medium, size: 14)
        l.textColor = AppColor.gray100
        l.textAlignment = .center
        l.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
        self.name.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 강제로 레이아웃을 적용하여 실제 frame을 얻음
        image.layoutIfNeeded()
    }
    
    //레이아웃까지
    private func setupUI() {
        self.contentView.addSubview(imageBackground)
        imageBackground.addSubview(image)
        self.contentView.addSubview(name)
        
        imageBackground.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(image.snp.width).multipliedBy(1.0)
        }
        
        image.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(3)
            make.horizontalEdges.equalToSuperview()
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    public func configure(name : String, imageURL: String) {
        if let url = URL(string: imageURL) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        self.name.text = name
    }
}
