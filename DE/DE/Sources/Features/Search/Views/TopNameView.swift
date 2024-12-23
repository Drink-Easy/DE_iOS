// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

class TopNameView: UIView {

    public lazy var backBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = Constants.AppColor.gray80
        $0.backgroundColor = .clear
    }
    
    public lazy var likeBtn = UIButton().then {
        $0.setImage(UIImage(named: "like_nfill"), for: .normal)
        $0.backgroundColor = .clear
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
    }
    
    public lazy var name = UILabel().then {
        $0.text = "루이 로드레 크리스탈 2015"
        $0.textColor = Constants.AppColor.DGblack
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.AppColor.grayBG
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [backBtn, likeBtn, name].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        backBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(19)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(31)
        }
        
        likeBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-26)
            $0.width.height.equalTo(30)
        }
        
        name.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(26)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(25)
            $0.bottom.equalToSuperview()
        }
    }
}
