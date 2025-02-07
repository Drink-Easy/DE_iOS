// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

final class ToasterToastMessageView: UIView {
    
    // MARK: - UI Components
    private let toastLabel = UILabel().then {
        $0.textColor = AppColor.white
        $0.font = UIFont.ptdBoldFont(ofSize: 10)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ToasterToastMessageView {
    func setupStyle() {
        self.backgroundColor = AppColor.gray100
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
    }
    
    func setupHierarchy() {
        addSubview(toastLabel)
    }
    
    func setupLayout() {
        toastLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(16)
        }
    }
}

extension ToasterToastMessageView {
    func setupDataBind(message: String) {
        toastLabel.text = message
        toastLabel.sizeToFit() // 텍스트 크기에 맞게 조정
        let padding: CGFloat = 32 // 좌우 패딩 (양쪽 16씩)
        self.frame.size = CGSize(width: toastLabel.frame.width + padding,
                                 height: 46) // 높이 자동 조절
    }
}
