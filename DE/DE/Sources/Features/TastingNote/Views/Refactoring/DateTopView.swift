// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

/// 페이지네이션 + 빅타이틀
class DateTopView: UIView {
    
    var currentPage: Int?
    var entirePage: Int?
    
    private lazy var page = UILabel().then {
        $0.font = UIFont.ptdMediumFont(ofSize: 16)
    }
    
    public lazy var styledLabel =  UILabel()

    init(currentPage: Int, entirePage: Int) {
        super.init(frame: .zero)
        backgroundColor = AppColor.bgGray
        self.currentPage = currentPage
        self.entirePage = entirePage
        
        self.addComponents()
        self.constraints()
        updatePageLabel()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func createStyledLabel(result: String, text: String) -> UILabel {
        let label = UILabel()

        let nicknameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .foregroundColor: AppColor.purple100!
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .foregroundColor: AppColor.black!
        ]

        let fullText = "\(result)\n\(text)"
        let attributedString = NSMutableAttributedString(string: fullText)

        if let nicknameRange = fullText.range(of: "\(result)") {
            let nsRange = NSRange(nicknameRange, in: fullText)
            attributedString.addAttributes(nicknameAttributes, range: nsRange)
        }

        if let secondLineRange = fullText.range(of: "\(text)") {
            let nsRange = NSRange(secondLineRange, in: fullText)
            attributedString.addAttributes(textAttributes, range: nsRange)
        }

        label.attributedText = attributedString
        label.textAlignment = .left
        label.numberOfLines = 2 // 반드시 두 줄로 설정
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈

        return label
    }
    
    public func setLabel(result: String, commonText: String) {
        styledLabel = createStyledLabel(result: result, text: commonText)
    }
    
    private func updatePageLabel() {
        guard let currentPage = currentPage, let entirePage = entirePage else { return }
        configureFractionLabel(page, currentPage: "\(currentPage)", entirePage: "\(entirePage)")
    }
    
    public func configureFractionLabel(_ label: UILabel, currentPage: String, entirePage: String) {
        let fullText = "\(currentPage)/\(entirePage)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let slashIndex = (currentPage as NSString).length
        attributedText.addAttribute(.foregroundColor, value: AppColor.purple70!, range: NSRange(location: 0, length: slashIndex))
        attributedText.addAttribute(.foregroundColor, value: AppColor.gray70!, range: NSRange(location: slashIndex, length: fullText.count - slashIndex))
        
        label.attributedText = attributedText
    }
    
    private func addComponents() {
        [page, styledLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        page.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        styledLabel.snp.makeConstraints {
            $0.top.equalTo(page.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

