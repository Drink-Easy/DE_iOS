// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class MyWineTableViewCell: UITableViewCell {
    
    static let identifier = "MyWineTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let wineImage = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.contentMode = .scaleAspectFit
    }
    
    let wineName = UILabel().then {
        $0.text = "루이 로드레 빈티지 브륏"
        $0.font = .ptdSemiBoldFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let winePrice = UILabel().then {
        $0.text = "구매가 78,000원"
        $0.font = .ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray100
        $0.textAlignment = .center
    }
    
    let datePassed = UILabel().then {
        $0.text = "D+212"
        $0.font = .ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.purple100
    }
    
    private func setupUI() {
        addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        
        addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.leading.equalTo(wineImage.snp.trailing).offset(18)
            make.top.equalTo(wineImage.snp.top).offset(13)
        }
        
        addSubview(winePrice)
        winePrice.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(8)
            make.leading.equalTo(wineName.snp.leading)
        }
    }

    
}
