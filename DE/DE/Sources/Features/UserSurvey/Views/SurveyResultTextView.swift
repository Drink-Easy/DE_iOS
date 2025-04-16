// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit
import Then

class SurveyResultTextView: UIView {
    public lazy var styledLabel =  UILabel()
    private var blurView: UIVisualEffectView?
    
    private func createStyledLabel(result: String, text: String) -> UILabel {
        let label = UILabel()

        let nicknameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(.semiBold, size: 34),
            .foregroundColor: AppColor.purple70
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(.medium, size: 26),
            .foregroundColor: AppColor.black
        ]

        let fullText = "\(result) \(text)"
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setLayout()
    }
    
    public func setLabel(result: String, commonText: String) {
        styledLabel = createStyledLabel(result: result, text: commonText)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLayout() {
        addSubview(styledLabel)
        styledLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    public func addBlurEffect() {
        guard blurView == nil else { return } // 이미 블러가 있으면 중복 추가 방지
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        guard let blurView = blurView else { return }

        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Bring styledLabel to front
        bringSubviewToFront(styledLabel)
    }

    /// 블러 뷰 제거
    public func removeBlurEffect() {
        blurView?.removeFromSuperview()
        blurView = nil
    }

}
