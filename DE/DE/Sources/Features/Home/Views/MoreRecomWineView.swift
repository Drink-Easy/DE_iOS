// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import DesignSystem

class MoreRecomWineView: UIView {
    
    public lazy var title = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.semiBold, size: 24)
    }
    
    public lazy var moreWineTableView = UITableView().then {
        $0.register(MoreWineTableViewCell.self, forCellReuseIdentifier: "MoreWineTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = AppColor.background
        $0.showsVerticalScrollIndicator = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, moreWineTableView].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(25)
        }
        
        moreWineTableView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
