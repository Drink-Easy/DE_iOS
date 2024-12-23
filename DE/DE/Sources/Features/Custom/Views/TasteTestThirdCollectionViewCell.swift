//
//  TasteTestThirdCollectionViewCell.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit

class TasteTestThirdCollectionViewCell: UICollectionViewCell {
    
    let View: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16.5
        v.layer.masksToBounds = true
        v.backgroundColor = .white
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor(hex: "C3C3C3")?.cgColor
        return v
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
        self.View.addSubview(name)
        self.contentView.backgroundColor = .clear
  
        View.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        name.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(View)
        }
    }
    
    func configure(name: String) {
        self.name.text = name
        if (name == "기타") {
            View.backgroundColor = UIColor(hex: "E6E6E6")
        }
    }
}
