// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class NoticeTableViewCell: UITableViewCell {
    
    public static let identifier = "NoticeTableViewCell"

    public lazy var title = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.ptdMediumFont(ofSize: 16)
        $0.numberOfLines = 1
    }
    
    public lazy var date = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.ptdRegularFont(ofSize: 11)
        $0.numberOfLines = 1
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColor.bgGray
        contentView.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [title, date].forEach { contentView.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(superViewWidth*0.6)
        }
        
        date.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    public func configure(title : String, date: String) {
        self.title.text = title
        self.date.text = date
    }
    
}
