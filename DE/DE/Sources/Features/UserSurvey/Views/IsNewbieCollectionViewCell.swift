// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import SnapKit

class IsNewbieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "IsNewbieCollectionViewCell"
    
    public lazy var contents = UILabel().then {
        $0.textColor = AppColor.gray90
        $0.font = UIFont.ptdMediumFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    
    private lazy var emoji = UILabel().then {
        $0.font = UIFont.ptdBoldFont(ofSize: 38)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColor.gray10
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [emoji, contents].forEach{ contentView.addSubview($0) }
    }
    
    private func constraints() {
        emoji.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        contents.snp.makeConstraints {
            $0.leading.equalTo(emoji.snp.trailing).offset(24)
            $0.centerY.equalTo(emoji)
        }
    }
    
    public func configure(model: IsNewbieModel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdMediumFont(ofSize: 20),
            .foregroundColor: AppColor.gray90!,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: model.contents, attributes: attributes)
        
        // ✅ 기존 contents UILabel을 사용하여 적용
        contents.attributedText = attributedText
        emoji.text = model.emoji
    }
    
//    public func configure(model: IsNewbieModel) {
//        contents.text = model.contents
//        emoji.text = model.emoji
//        
//        contents = UILabel().then({
//            let text = model.contents
//            
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 4
//            paragraphStyle.alignment = .left
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.ptdMediumFont(ofSize: 20),
//                .foregroundColor: AppColor.gray90!,
//                .paragraphStyle: paragraphStyle
//            ]
//            
//            let attributedText = NSAttributedString(string: text, attributes: attributes)
//            
//            $0.attributedText = attributedText
//            $0.numberOfLines = 0
//        })
//        
//    }
    
    public func updateSelectionState(isSelected: Bool) {
        contentView.backgroundColor = isSelected ? AppColor.purple10 : AppColor.gray10
        contentView.layer.borderWidth = isSelected ? 1 : 0
        contentView.layer.borderColor = isSelected ? AppColor.purple70?.cgColor : AppColor.gray10?.cgColor
        self.contents.font = isSelected ? UIFont.ptdSemiBoldFont(ofSize: 20) : UIFont.ptdMediumFont(ofSize: 20)
        self.contents.textColor = isSelected ? AppColor.purple100 : AppColor.gray90
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = AppColor.gray10
        self.layer.borderWidth = 0
        self.layer.borderColor = AppColor.gray10?.cgColor
        self.contents.font = UIFont.ptdMediumFont(ofSize: 20)
        self.contents.textColor = AppColor.gray90
        self.contents.attributedText = nil // ✅ 기존 AttributedText 초기화
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.backgroundColor = AppColor.gray10
//        self.layer.borderWidth = 0
//        self.layer.borderColor = AppColor.gray10?.cgColor
//        self.contents.font = UIFont.ptdMediumFont(ofSize: 20)
//        self.contents.textColor = AppColor.gray90
//    }
}
