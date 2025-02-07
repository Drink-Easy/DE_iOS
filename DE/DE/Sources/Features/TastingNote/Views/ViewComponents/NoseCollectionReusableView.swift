// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import SnapKit

class NoseCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    weak var delegate: NoseHeaderViewDelegate? // 델리게이트 선언
    private var section: Int = 0 // 섹션 번호 저장
    static let identifier = "NoseCollectionReusableView"
    
    // 타이틀 레이블
    private let titleLabel = UILabel().then { label in
        label.font = .ptdSemiBoldFont(ofSize: 18)
        label.textColor = AppColor.black
    }
    
    // 화살표 아이콘 - 열려있을 떄만 보이게. 기본 값이 안보기에
    private let iconImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "chevron.up") // 시스템 아이콘
        imageView.tintColor = AppColor.gray90
        imageView.isHidden = true // 기본 상태에서 숨김 처리
    }

    // 분리선
    private let separatorView = UIView().then { view in
        view.backgroundColor = AppColor.gray30
    }
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // UI 설정
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped))) // 터치 제스처 추가
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        [titleLabel, iconImageView, separatorView].forEach{ self.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20) // 아이콘 크기 20x20
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - 데이터 설정
    func configure(with title: String, section: Int, delegate: NoseHeaderViewDelegate, isExpanded: Bool) {
        titleLabel.text = title
        self.section = section
        self.delegate = delegate
        
        iconImageView.isHidden = !isExpanded
        separatorView.isHidden = isExpanded
    }
    
    // MARK: - 액션 처리
    @objc private func headerTapped() {
        delegate?.toggleSection(section) // 섹션 토글 메서드 호출
    }
}
