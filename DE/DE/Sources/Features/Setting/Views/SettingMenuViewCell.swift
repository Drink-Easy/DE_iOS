// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import CoreModule
import Network

public class SettingMenuViewCell: UITableViewCell {
    
    public static let identifier = "SettingMenuViewCell"

    public lazy var title = UILabel().then {
        $0.textColor = AppColor.DGblack
        $0.font = UIFont.ptdRegularFont(ofSize: 16)
        $0.numberOfLines = 1
    }
    
    public lazy var rightArrow = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = AppColor.gray50
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = AppColor.bgGray
        contentView.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = nil
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [title, rightArrow].forEach { self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
        }
        
        rightArrow.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.height.equalTo(18)
            $0.trailing.equalToSuperview()
        }
    }
    
    public func configure(name: String) {
        self.title.text = name
    }
}
