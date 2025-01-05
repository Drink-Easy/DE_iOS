// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class CustomDropdownView: UIView {
    
    // MARK: - Properties
    private let dropdownButton = UIButton(type: .system)
    private let dropdownMenu = UIView()
    private var isDropdownVisible = false
    
    private var options: [String]
    private var selectedOptionIndex: Int = 0
    public var onOptionSelected: ((String) -> Void)?
    
    public var selectedOption: String {
        return options[selectedOptionIndex]  // 현재 선택된 옵션 확인 변수
    }
    
    private var optionLabels: [UILabel] = []
    
    // MARK: - Initializer
    init(options: [String], onOptionSelected: ((String) -> Void)? = nil) {
        self.options = options
        self.onOptionSelected = onOptionSelected
        super.init(frame: .zero)
        setupView()
        updateSelectedOption(index: 0)
        dropdownMenu.isHidden = true
        dropdownMenu.alpha = 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        setupDropdownButton()
        setupDropdownMenu()
    }
    
    private func setupDropdownButton() {
        dropdownButton.setTitle(options.first ?? "Select", for: .normal)
        dropdownButton.setTitleColor(AppColor.gray50, for: .normal)
        dropdownButton.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 12)
        dropdownButton.setImage(UIImage(named: "down"), for: .normal)
        dropdownButton.tintColor = AppColor.gray50
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.contentHorizontalAlignment = .center
        dropdownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        dropdownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        
        addSubview(dropdownButton)
        dropdownButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupDropdownMenu() {
        dropdownMenu.backgroundColor = .white
        dropdownMenu.layer.cornerRadius = 8
        dropdownMenu.layer.shadowColor = UIColor.black.cgColor
        dropdownMenu.layer.shadowOpacity = 0.1
        dropdownMenu.layer.shadowOffset = CGSize(width: 0, height: 2)
        dropdownMenu.layer.shadowRadius = 8
        dropdownMenu.isHidden = true
        dropdownMenu.alpha = 0.0
        addSubview(dropdownMenu)
        
        dropdownMenu.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(dropdownButton).inset(5)
            $0.height.equalTo(35 * options.count)
        }
        
        for (index, option) in options.enumerated() {
            let optionLabel = UILabel()
            optionLabel.text = option
            optionLabel.textColor = AppColor.gray50
            optionLabel.font = UIFont.ptdMediumFont(ofSize: 12)
            optionLabel.textAlignment = .left
            optionLabel.isUserInteractionEnabled = true
            optionLabel.tag = index
            optionLabels.append(optionLabel)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectOption(_:)))
            optionLabel.addGestureRecognizer(tapGesture)
            
            dropdownMenu.addSubview(optionLabel)
            optionLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.height.equalTo(35)
                if index == 0 {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalTo(optionLabels[index - 1].snp.bottom)
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        self.superview?.bringSubviewToFront(self)
        
        if isDropdownVisible {
            dropdownMenu.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dropdownMenu.alpha = self.isDropdownVisible ? 1.0 : 0.0
        }) { _ in
            if !self.isDropdownVisible {
                self.dropdownMenu.isHidden = true
            }
        }
    }

    @objc private func didSelectOption(_ gesture: UITapGestureRecognizer) {
        guard let selectedLabel = gesture.view as? UILabel else { return }
        updateSelectedOption(index: selectedLabel.tag)
        toggleDropdown()
    }
    
    private func updateSelectedOption(index: Int) {
        selectedOptionIndex = index
        dropdownButton.setTitle(options[index], for: .normal)
        onOptionSelected?(options[index])
        
        for (idx, label) in optionLabels.enumerated() {
            label.textColor = (idx == index) ? AppColor.black : AppColor.gray50
            label.font = (idx == index) ? UIFont.ptdSemiBoldFont(ofSize: 12) : UIFont.ptdMediumFont(ofSize: 12)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 1. 드롭다운 버튼 영역 터치 감지
        if dropdownButton.frame.contains(point) {
            return dropdownButton
        }
        
        // 2. 드롭다운 메뉴 영역 터치 감지 (좌표 변환 필수)
        let convertedPoint = convert(point, to: dropdownMenu)
        if dropdownMenu.bounds.contains(convertedPoint) && !dropdownMenu.isHidden {
            return dropdownMenu.hitTest(convertedPoint, with: event)
        }
        
        // 3. 기본 동작 처리 (터치 이벤트 무시)
        return super.hitTest(point, with: event)
    }

}
