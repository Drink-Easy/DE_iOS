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

struct Section {
    var title: String
    var isExpanded: Bool
    var items: [String]
}

final class ExpandableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ExpandableHeaderView"
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
    
    // MARK: - Properties
    
    var section: Int = 0
    var tapAction: ((Int) -> Void)?
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
//        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        contentView.addSubviews(titleLabel, chevronImageView)
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
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
