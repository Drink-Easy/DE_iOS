// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class NoteListView: UIView {
    
    let navView = CustomSearchNavigationBar().then {
        $0.backgroundColor = AppColor.gray20
    }
    
    private let noteListLabel =  UILabel().then {
        $0.text = "노트 보관함"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 24)
    }
    
    private let vectorView = UIView().then {
        $0.backgroundColor = AppColor.purple100
    }
    
    private let totalWineLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(noteListLabel)
        addSubview(vectorView)
        addSubview(totalWineLabel)
        addSubview(navView)
        
        navView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        noteListLabel.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom).offset(6)
            make.leading.equalTo(navView.snp.leading).offset(24)
        }
        
        vectorView.snp.makeConstraints { make in
            make.leading.equalTo(noteListLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(noteListLabel.snp.bottom).offset(8)
        }
        
        totalWineLabel.snp.makeConstraints { make in
            make.top.equalTo(vectorView.snp.bottom).offset(36)
            make.leading.equalTo(vectorView.snp.leading)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(totalWineLabel.snp.bottom)
        }
        
        
    }
    
    func updateTotalWineCount(count: Int) {
        totalWineLabel.text = "Total \(count)병"
    }
}
