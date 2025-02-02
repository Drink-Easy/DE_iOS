// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network
// 기기대응 완료
// 와인 날짜 선택 뷰

class MyWineDateView: UIView {
    public lazy var topView = NoCountDateTopView()
    
    lazy var calendarContainer = UIView().then {
        $0.backgroundColor = AppColor.white
        $0.layer.cornerRadius = 10
        
        // 그림자 설정
        $0.layer.shadowColor = UIColor.black.cgColor  // 그림자 색상
        $0.layer.shadowOpacity = 0.1                 // 그림자 투명도 (0.0 ~ 1.0)
        $0.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자 위치 (x, y)
        $0.layer.shadowRadius = 4                   // 그림자 흐림 정도
        $0.layer.masksToBounds = false              // 그림자 잘리지 않게 설정
    }
    
    lazy var calender = UICalendarView().then {
        $0.timeZone = .current
        $0.backgroundColor = .clear
        $0.calendar = .current
        $0.locale = Locale(identifier: "ko_KR")
        $0.fontDesign = .rounded
//        $0.layer.cornerRadius = 10
        $0.wantsDateDecorations = true
        $0.tintColor = AppColor.purple100
    }
    
    public lazy var nextButton = CustomButton(title: "다음", isEnabled: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWineName(_ name: String) {
        self.topView.title.text = name
        self.topView.desp.text = "구매 일자를 선택해주세요"
    }
    
    func setupUI() {
        backgroundColor = .clear
        calendarContainer.addSubview(calender)
        [topView, calendarContainer, nextButton].forEach{ addSubview($0) }
    }
    
    func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(80)
        }
        
        calender.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(16))
        }
        
        calendarContainer.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(DynamicPadding.dynamicValue(30)) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(calendarContainer.snp.width).multipliedBy(1.15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40)) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
    }

}


