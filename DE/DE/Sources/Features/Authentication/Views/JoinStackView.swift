// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import SnapKit
import CoreModule
import DesignSystem

public class JoinStackView: UIView {
    private let label = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = AppColor.gray50
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private let joinButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(AppColor.purple100, for: .normal)
        $0.backgroundColor = .clear
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [label, joinButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8 // 라벨과 버튼 사이 간격
        $0.alignment = .center
    }
    
    public init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 부모 뷰의 모든 가장자리에 맞춤
        }
    }
    
    func setJoinButtonAction(target: Any, action: Selector) {
        joinButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
