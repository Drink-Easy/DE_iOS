// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import CoreModule
import Network

public class NoticeTableViewCell: UITableViewCell {
    
    public static let identifier = "NoticeTableViewCell"

    public lazy var title = UILabel().then {
        $0.textColor = AppColor.DGblack
        $0.font = UIFont.ptdMediumFont(ofSize: 16)
        $0.numberOfLines = 1
    }
    
    public lazy var date = UILabel().then {
        $0.textColor = AppColor.gray70
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.numberOfLines = 1
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = AppColor.background
        contentView.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = nil
        self.date.text = nil
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [title, date].forEach { self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            //$0.top.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(DynamicPadding.dynamicValue(24))
            $0.width.equalTo(Constants.superViewWidth * 0.6)
        }
        
        date.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
    }
    
    public func configure(data: NoticeResponse) {
        self.title.text = "[\(data.tag)] \(data.title)"
        self.date.text = data.createdAt
    }
}
