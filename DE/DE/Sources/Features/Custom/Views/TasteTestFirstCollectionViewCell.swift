//
//  TasteTestFirstCollectionViewCell.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit

class TasteTestFirstCollectionViewCell: UICollectionViewCell {
    var kindEngName : String = ""
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
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
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(name)
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
  
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(imageView)
        }
    }
    
    func configure(imageName: String, kindName : String) {
        if let image = UIImage(named: imageName) {
            self.name.text = imageName
            imageView.image = image
            self.kindEngName = kindName
        }
    }
}
