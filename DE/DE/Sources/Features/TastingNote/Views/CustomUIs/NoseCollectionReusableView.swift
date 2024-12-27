// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class NoseCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    weak var delegate: NoseHeaderViewDelegate? // 델리게이트 선언
    private var section: Int = 0 // 섹션 번호 저장
    static let identifier = "NoseCollectionReusableView"
    
    // 타이틀 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // 화살표 아이콘 - 열려있을 떄만 보이게. 기본 값이 안보기에
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down") // 시스템 아이콘
        imageView.tintColor = .black
        imageView.isHidden = true // 기본 상태에서 숨김 처리
        return imageView
    }()
    
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
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            // TODO : 레이아웃 피그마랑 똑같에 맞추기
            make.leading.equalTo(titleLabel.snp.trailing).offset(16) // titleLabel 옆 16포인트 간격(이건 피그마보고 조정해야할듯? 임시로 해놓은 것)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20) // 아이콘 크기 20x20
        }
    }
    
    // MARK: - 데이터 설정
    func configure(with title: String, section: Int, delegate: NoseHeaderViewDelegate, isExpanded: Bool) {
        titleLabel.text = title
        self.section = section
        self.delegate = delegate
        
        iconImageView.isHidden = !isExpanded
    }
    
    // MARK: - 액션 처리
    @objc private func headerTapped() {
        delegate?.toggleSection(section) // 섹션 토글 메서드 호출
    }
}
