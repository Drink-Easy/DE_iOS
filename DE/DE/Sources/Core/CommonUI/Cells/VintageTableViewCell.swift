// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public final class VintageTableViewCell: UITableViewCell {

    public static let identifier = "VintageTableViewCell"
    
    // MARK: - Components
    private var year = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.medium, size: 14)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.setLineSpacingPercentage(0.5)
    }
    
    private var score = UILabel().then {
        $0.textColor = AppColor.purple100
        $0.font = UIFont.pretendard(.regular, size: 14)
        $0.setLineSpacingPercentage(0.2)
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = AppColor.gray10
    }

    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.year.text = nil
        self.score.text = nil
    }
    
    // MARK: - SetUp
    private func setupView() {
        contentView.backgroundColor = AppColor.background
    }
    
    private func addComponents() {
        addSubviews(year, score, underLine)
    }
    
    private func constraints() {
        year.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        score.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(year)
        }
        
        underLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    // MARK: - Configure
    public func configure(year: Int, score: Double) {
        self.year.text = "\(year)"
        self.score.text = "★ \(String(format: "%.1f", score))"
    }
    
}
