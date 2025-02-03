// Copyright © 2024 DRINKIG. All rights reserved
import Foundation
import UIKit
import SnapKit
import Moya
import SDWebImage
import CoreModule

class NoteCollectionViewCell: UICollectionViewCell { // 셀에 이미지와 label을 추가하기 위한 커스텀 셀
    
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = AppColor.winebg
    }
    
    private lazy var image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    let nameLabel = UILabel()
    
    static let identifier = "NoteCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageBackground)
        imageBackground.addSubview(image)
        contentView.addSubview(nameLabel)
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        
        imageBackground.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        image.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(3)
            make.horizontalEdges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageBackground.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.centerX.equalTo(imageBackground.snp.centerX)
            make.height.equalTo(16)
        }
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(name : String, imageURL: String) {
        if let url = URL(string: imageURL) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        
        self.nameLabel.text = name
    }
}
