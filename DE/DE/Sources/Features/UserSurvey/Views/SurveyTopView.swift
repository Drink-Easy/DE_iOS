// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import SnapKit

class SurveyTopView: UIView {
    
    var currentPage: Int?
    var entirePage: Int?
    
    private lazy var page = UILabel().then {
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    private lazy var title = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.semiBold, size: 24)
        $0.numberOfLines = 0
    }
    
    public func setTitleLabel(_ text: String, lineSpacing: CGFloat = 2) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: title.font ?? UIFont.pretendard(.semiBold, size: 24), // ✅ 기존 폰트 유지
            .foregroundColor: title.textColor ?? AppColor.black,    // ✅ 기존 색상 유지
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        title.attributedText = attributedText
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
        attributedText.addAttribute(.foregroundColor, value: AppColor.purple70, range: NSRange(location: 0, length: slashIndex))
        attributedText.addAttribute(.foregroundColor, value: AppColor.gray70, range: NSRange(location: slashIndex, length: fullText.count - slashIndex))
        
        label.attributedText = attributedText
    }
    
    private func addComponents() {
        [page, title].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        page.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(25)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(page.snp.bottom).offset(4)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
            $0.bottom.equalToSuperview()
        }
    }
}
