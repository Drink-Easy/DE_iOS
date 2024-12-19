//
//  CustomSuggestionCell.swift
//  Drink-EG
//
//  Created by 이수현 on 8/10/24.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class CustomSuggestionCell: UITableViewCell {

    let suggestionImageView = UIImageView()
    let suggestionLabel = UILabel()
    let selectionIndicator = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(suggestionImageView)
        addSubview(suggestionLabel)
        addSubview(selectionIndicator)
        
        // 이미지 뷰 설정
        suggestionImageView.contentMode = .scaleAspectFill
        suggestionImageView.layer.cornerRadius = 10
        suggestionImageView.clipsToBounds = true

        // 라벨 설정
        suggestionLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        suggestionLabel.textColor = .black
        suggestionLabel.numberOfLines = 2

        // 선택된 상태를 나타내는 이미지 (체크박스 같은 용도)
        selectionIndicator.contentMode = .scaleAspectFill

        // 레이아웃 설정
        suggestionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(80)
        }
        
        suggestionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(suggestionImageView.snp.trailing).offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.width.greaterThanOrEqualTo(82)
        }
        
        selectionIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.greaterThanOrEqualTo(22)
        }
    }
    
    func configure(with wine: Wine, isSelected: Bool) {
        let imageURL = URL(string: wine.imageUrl!)
        suggestionImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        suggestionLabel.text = wine.name
        selectionIndicator.image = isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square  ")
        selectionIndicator.tintColor = isSelected ? .systemOrange : .lightGray
    }
}
