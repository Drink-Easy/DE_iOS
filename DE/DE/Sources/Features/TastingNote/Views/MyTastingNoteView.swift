// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit
import Then
import CoreModule

// 테이스팅 목록 표시 뷰
class MyTastingNoteView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: Constants.superViewWidth*0.27, height: Constants.superViewWidth*0.35)
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 22
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
    }
    
    private let vector = UIView().then {
        $0.backgroundColor = UIColor(hex: "DBDBDB")
    }
    
    private let tastingNoteLabel = UILabel().then {
        $0.text = "나의 테이스팅 노트"
        $0.font  = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    let writeButton = UIButton().then {
        $0.setImage(UIImage(named: "writeNote"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        addSubview(vector)
        vector.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(tastingNoteLabel)
        tastingNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(40)
            make.leading.equalTo(vector.snp.leading)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tastingNoteLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(writeButton)
        writeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
