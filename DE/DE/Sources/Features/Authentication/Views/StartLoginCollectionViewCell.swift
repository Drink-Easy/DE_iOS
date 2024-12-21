// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let label1: UILabel = {
        let l1 = UILabel()
        l1.font = UIFont.ptdBoldFont(ofSize: 33)
        l1.textColor = .white
        l1.textAlignment = .center
        l1.numberOfLines = 0
        return l1
    }()
    
    private let label2: UILabel = {
        let l2 = UILabel()
        l2.font = UIFont.ptdMediumFont(ofSize: 14)
        l2.textColor = .white
        l2.textAlignment = .center
        l2.numberOfLines = 0
        return l2
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(imageView)
        addSubview(label1)
        addSubview(label2)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        label1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.superViewHeight * 0.6)
            make.leading.equalTo(Constants.padding)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(20)
            make.leading.equalTo(Constants.padding)
        }
    }
    
    func configure(imageName: String, label1: String, label2: String) {
        if let image = UIImage(named: imageName) {
            imageView.image = image
        }
        self.label1.text = label1
        self.label2.text = label2
    }
    
}
