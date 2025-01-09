// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class NoteListView: UIView {
    
    private let noteListLabel =  UILabel().then {
        $0.text = "노트 보관함"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 24)
    }
    
    let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = AppColor.gray90
    }
    
    private let vectorView = UIView().then {
        $0.backgroundColor = AppColor.purple100
    }
    
    private let totalWineLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .ptdSemiBoldFont(ofSize: 20)
    }
    
    let seeAllLabel = UILabel().then {
        $0.text = "모두보기"
        $0.textColor = AppColor.gray80
        $0.textAlignment = .center
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.isUserInteractionEnabled = true // 터치 이벤트 활성화
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
        addSubview(searchButton)
        addSubview(vectorView)
        addSubview(totalWineLabel)
        addSubview(seeAllLabel)
        
        noteListLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(23)
            make.leading.equalToSuperview().offset(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(noteListLabel.snp.top).offset(5)
            make.centerY.equalTo(noteListLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
            
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
        
        seeAllLabel.snp.makeConstraints { make in
            make.top.equalTo(totalWineLabel.snp.top).offset(9)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(totalWineLabel.snp.bottom)
        }
        
        
    }
    
    func updateTotalWineCount(count: Int) {
        totalWineLabel.text = "전체 \(count)병"
    }
}
