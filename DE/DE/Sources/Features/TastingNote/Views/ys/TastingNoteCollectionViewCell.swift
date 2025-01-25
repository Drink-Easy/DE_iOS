// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class TastingNoteCollectionViewCell: UICollectionViewCell {
    
    public lazy var image = UIImageView().then { i in
        i.contentMode = .scaleAspectFit
        i.layer.cornerRadius = 8
        i.layer.masksToBounds = true
        i.backgroundColor = AppColor.winebg
    }
    
    public lazy var name = UILabel().then { l in
        l.font = UIFont.ptdMediumFont(ofSize: 14)
        l.textColor = Constants.AppColor.gray100
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
        self.contentView.addSubview(image)
        self.contentView.addSubview(name)
        
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(image.snp.width).multipliedBy(1.0)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }
}
