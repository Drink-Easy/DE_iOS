//
//  NoteListView.swift
//  Drink-EG
//
//  Created by 이수현 on 9/28/24.
//

import UIKit
import SnapKit

class NoteListView: UIView {
    
    private let noteListLabel: UILabel = {
        let label = UILabel()
        label.text = "노트 보관함"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        return label
    }()
    
    private let vectorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "7E13B1")
        return view
    }()
    
    private let totalWineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    
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
        
        noteListLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
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
    }
    
    func updateTotalWineCount(count: Int) {
        totalWineLabel.text = "Total \(count)병"
    }
}
