//
//  TasteTestSecondCollectionViewCell.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit

class TasteTestSecondCollectionViewCell: UICollectionViewCell {
    var nationEngName : String = ""
    
    let View: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor(hex: "545454")
        return v
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        return iv
    }()
    
    let name: UILabel = {
        let l1 = UILabel()
        l1.font = .boldSystemFont(ofSize: 16)
        l1.textColor = .black
        l1.numberOfLines = 0
        return l1
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.contentView.addSubview(View)
        self.View.addSubview(imageView)
        self.contentView.addSubview(name)
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
  
        View.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(View.snp.width)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(View.snp.bottom).offset(10)
            make.centerX.equalTo(View)
        }
    }
    
    func configure(imageName: String, nationName: String) {
        if let image = UIImage(named: imageName) {
            if (imageName == "기타1") {
                self.name.text = "기타"
            } else {
                self.name.text = imageName
            }
            imageView.image = image
            self.nationEngName = nationName
        }
    }
}
