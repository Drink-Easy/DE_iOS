//
//  ExpandableHeaderView.swift
//  DE
//
//  Created by 김도연 on 6/8/25.
//

import UIKit
import DesignSystem

import SnapKit
import Then

// MARK: - ExpandableHeaderViewDelegate
/// 헤더뷰의 이벤트를 처리하기 위한 델리게이트 프로토콜
public protocol ExpandableHeaderViewDelegate: AnyObject {
    func expandableHeaderView(_ headerView: ExpandableHeaderView, didTapSection section: Int)
}

// MARK: - ExpandableHeaderView
public final class ExpandableHeaderView: UITableViewHeaderFooterView {
    public static let identifier = "ExpandableHeaderView"
    
    // MARK: - UI Components 선언
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = AppColor.black
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = AppColor.gray70
        $0.contentMode = .scaleAspectFit
        $0.isHidden = false
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = AppColor.gray10
    }
    
    // MARK: - Properties
    var section: Int = 0
    public weak var delegate: ExpandableHeaderViewDelegate?
    
    // 애니메이션 설정
    private var animationDuration: TimeInterval = 0.3
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubviews(titleLabel, chevronImageView, underLine)
        contentView.backgroundColor = AppColor.background
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        underLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    // MARK: - Setup Gesture
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        delegate?.expandableHeaderView(self, didTapSection: section)
    }
}

// MARK: - Configure with Section
public extension ExpandableHeaderView {
    /// Section 객체를 직접 받아서 헤더뷰를 구성합니다
    /// - Parameters:
    ///   - section: 섹션 데이터 객체
    ///   - index: 테이블뷰에서의 섹션 인덱스
    func configure<Item: SectionItem>(with section: Section<Item>, at index: Int) {
        // 섹션 인덱스 저장
        self.section = index
        
        // 타이틀 설정
        AppTextStyle.KR.body2
            .apply(to: titleLabel, text: section.title, color: AppColor.black)
        
        // 아이템이 있는지 확인하여 chevron 표시 여부 결정
        let hasItems = !section.items.isEmpty
        chevronImageView.isHidden = !hasItems
        
        // 확장 상태에 따른 chevron 회전 (애니메이션 없이)
        updateChevron(isExpanded: section.isExpanded, animated: false)
    }
    
    private func updateChevron(isExpanded: Bool, animated: Bool) {
        // 확장 상태에 따른 회전 각도 결정
        // isExpanded가 true면 chevron이 위를 향하도록 180도 회전
        // isExpanded가 false면 원래 상태(아래 방향)로 복귀
        let transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        
        if animated {
            UIView.animate(withDuration: animationDuration) {
                self.chevronImageView.transform = transform
            }
        } else {
            chevronImageView.transform = transform
        }
    }
}
