// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class SimpleListView: UIView {
    // MARK: - Properties
    public lazy var titleLabel = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = .pretendard(.semiBold, size: 18)
    }
    
    public lazy var backView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    
    public lazy var editButton = UIButton().then {
        $0.setAttributedTitle(
            NSAttributedString(
                string: "수정하기",
                attributes: [
                    .font: UIFont.pretendard(.regular, size: 12), // 폰트 적용
                    .underlineStyle: NSUnderlineStyle.single.rawValue,    // 밑줄 스타일
                    .foregroundColor: AppColor.gray70
                ]
            ),
            for: .normal
        )
        $0.isHidden = true
        $0.isEnabled = true
    }
    
    public var items: [(title: String, value: String)] = [] {
        didSet {
            backView.backgroundColor = AppColor.white
            updateUI() // 데이터 변경 시 UI 업데이트
        }
    }
    
    private var stackViews: [UIStackView] = []
    private var lines: [UIView] = []
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        [titleLabel, backView, editButton].forEach {
            addSubview($0)
        }
        updateUI()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(8.0))
            make.leading.trailing.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - UI Update
    private func updateUI() {
        // 기존 스택뷰와 라인 제거
        
        stackViews.forEach { $0.removeFromSuperview() }
        lines.forEach { $0.removeFromSuperview() }
        stackViews.removeAll()
        lines.removeAll()
        
        // 새로 생성
        for (index, item) in items.enumerated() {
            let stack = createHorizontalStack(title: item.title, value: item.value)
            stackViews.append(stack)
            backView.addSubview(stack)
            
            // 마지막 아이템이 아닌 경우에만 라인 추가
            if index < items.count - 1 {
                let line = createline()
                lines.append(line)
                backView.addSubview(line)
            }
        }
        
        // 제약 조건 재설정
        for (index, stack) in stackViews.enumerated() {
            stack.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(40)
                
                if index == 0 {
                    make.top.equalToSuperview() // 첫 번째 스택뷰
                } else {
                    make.top.equalTo(lines[index - 1].snp.bottom) // 이전 라인 아래
                }
            }
            
            // 마지막 스택뷰가 아닌 경우에만 라인의 제약 조건 설정
            if index < lines.count {
                lines[index].snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(16)
                    make.height.equalTo(1)
                    make.top.equalTo(stack.snp.bottom)
                }
            }
        }
        
        backView.snp.updateConstraints { make in
            if items.count == 3 { //리스트 개수가 3일 때
                make.height.greaterThanOrEqualTo(124)
            } else { //리스트 개수가 2일 때
                make.height.greaterThanOrEqualTo(84)
            }
        }
    }
    
    // MARK: - Helpers
    private func createHorizontalStack(title: String, value: String) -> UIStackView {
        let titleLabel = createLabel(title: title, isTitle: true)
        let valueLabel = createLabel(title: value, isTitle: false)
        
        return UIStackView(arrangedSubviews: [titleLabel, valueLabel]).then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .fill
            $0.spacing = 8
        }
    }
    
    private func createLabel(title: String, isTitle: Bool) -> UILabel {
        let label = UILabel().then {
            $0.font = .pretendard(.regular, size: 14)
            $0.textAlignment = isTitle ? .left : .right
            
            // "구매일"로 인덱싱해서 특정 컬러 적용
            let attributedString = NSMutableAttributedString(string: title)
            
            if let rangeOfKeyword = title.range(of: "구매일") {
                let nsRange = NSRange(rangeOfKeyword, in: title)
                attributedString.addAttribute(.foregroundColor, value: AppColor.black, range: nsRange)
                
                if let remainingRange = title.range(of: title.replacingOccurrences(of: "구매일", with: "")) {
                    let nsRemainingRange = NSRange(remainingRange, in: title)
                    attributedString.addAttribute(.foregroundColor, value: AppColor.purple100, range: nsRemainingRange)
                }
            } else {
                // "구매일"이 없으면 기본 텍스트 적용
                $0.textColor = isTitle ? AppColor.black : AppColor.gray50
                $0.text = title
            }
            
            $0.attributedText = attributedString
        }
        return label
    }
    private func createline() -> UIView {
        return UIView().then {
            $0.backgroundColor = AppColor.gray30
        }
    }
    
    public func setEditButton(showEditButton: Bool = false) {
        self.editButton.isHidden = !showEditButton
    }
}
