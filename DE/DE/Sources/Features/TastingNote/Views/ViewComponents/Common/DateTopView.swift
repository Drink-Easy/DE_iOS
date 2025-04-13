// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

/// 날짜 있는 쪽에만 쓰는 페이지네이션 + 빅타이틀
class DateTopView: UIView {
    
    var currentPage: Int?
    var entirePage: Int?
    
    private lazy var page = UILabel().then {
        $0.font = UIFont.ptdMediumFont(ofSize: 16)
    }
    
    public lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
//
//    public lazy var title = UILabel().then {
//        $0.textColor = AppColor.purple100
//        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
//        $0.numberOfLines = 0
//    }
//    
//    private lazy var desp = UILabel().then {
//        $0.text = "시음 시기를 선택해주세요"
//        $0.textColor = AppColor.black
//        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
//        $0.numberOfLines = 1
//    }
    
    /// 제목과 설명을 하나의 라벨에서 관리
    /// - Parameters:
    ///   - title: 메인 제목
    ///   - titleColor: 메인 제목 색상 (기본값: `AppColor.purple100`)
    ///   - titleFont: 메인 제목 폰트 (기본값: `UIFont.ptdSemiBoldFont(ofSize: 24)`)
    ///   - description: 설명 텍스트
    ///   - descriptionColor: 설명 텍스트 색상 (기본값: `AppColor.black`)
    ///   - descriptionFont: 설명 텍스트 폰트 (기본값: `UIFont.ptdMediumFont(ofSize: 18)`)
    ///   - lineSpacing: 행간 (기본값: `2`)
    public func setTitleLabel(
        title: String,
        titleColor: UIColor = AppColor.purple100!,
        titleFont: UIFont = UIFont.ptdSemiBoldFont(ofSize: 24),
        description: String,
        descriptionColor: UIColor = AppColor.black!,
        descriptionFont: UIFont = UIFont.ptdSemiBoldFont(ofSize: 24),
        lineSpacing: CGFloat = 2
    ) {
        let fullText = "\(title)\n\(description)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let titleRange = (fullText as NSString).range(of: title)
        attributedString.addAttributes([
            .font: titleFont,
            .foregroundColor: titleColor,
            .paragraphStyle: paragraphStyle
        ], range: titleRange)
        
        let descriptionRange = (fullText as NSString).range(of: description)
        attributedString.addAttributes([
            .font: descriptionFont,
            .foregroundColor: descriptionColor,
            .paragraphStyle: paragraphStyle
        ], range: descriptionRange)
        
        titleLabel.attributedText = attributedString
    }

    init(currentPage: Int, entirePage: Int) {
        super.init(frame: .zero)
        backgroundColor = AppColor.background
        self.currentPage = currentPage
        self.entirePage = entirePage
        
        self.addComponents()
        self.constraints()
        updatePageLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        [page, titleLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        page.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(page.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}

