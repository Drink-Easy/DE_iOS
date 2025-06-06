// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Cosmos
import CoreModule
import DesignSystem
import Then

class OnlyReviewView: UIView {
    // 탑 - 와인 정보
    public lazy var header = UILabel().then {
        $0.numberOfLines = 0
    }
    public lazy var infoView = WineDetailView()
    
    // 리뷰
    let textViewPlaceHolder = "추가로 기록하고 싶은 내용을 작성해 보세요!"
    public lazy var reviewHeader = PropertyTitleView(type: .none)
    public lazy var reviewBody: UITextView = {
        let r = UITextView()
        r.layer.cornerRadius = 10
        r.text = textViewPlaceHolder
        r.textColor = AppColor.gray90
        r.font = UIFont.pretendard(.medium, size: 14)
        r.backgroundColor = AppColor.gray10
        r.isScrollEnabled = true
        r.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return r
    }()

    // 버튼
    public lazy var saveButton = CustomButton(title: "저장하기", isEnabled: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        reviewHeader.setName(eng: "Review", kor: "리뷰")
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setWineName(_ name: String) {
        AppTextStyle.KR.head.apply(to: self.header, text: name, color: AppColor.black)
    }
    
    private func addComponents() {
        [header, infoView, reviewHeader, reviewBody, saveButton].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview()
        }
        
        reviewHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(DynamicPadding.dynamicValue(50))
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        reviewBody.snp.makeConstraints { make in
            make.top.equalTo(reviewHeader.snp.bottom).offset(DynamicPadding.dynamicValue(24))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180) // 웬만하면 고정. 버튼 영역 침범 안되도록
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40)) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(reviewBody.snp.bottom).offset(40)
            make.height.equalTo(60)
        }
    }
}
