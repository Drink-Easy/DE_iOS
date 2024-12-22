//
//  MyTastingNote.swift
//  Drink-EG
//
//  Created by 이수현 on 9/28/24.
//

import Foundation
import UIKit
import SnapKit

// 테이스팅 목록 표시 뷰
class MyTastingNote: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: 107, height: 131)
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 22
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
    }
    
    private let vector: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "DBDBDB")
        return v
    }()
    
    private let tastingNoteLabel: UILabel = {
        let t = UILabel()
        t.text = "나의 테이스팅 노트"
        t.font  = UIFont(name: "Pretendard-SemiBold", size: 20)
        t.textColor = .black
        t.textAlignment = .left
        return t
    }()
    
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
            // make.width.equalTo(341)
            make.height.equalTo(500)
        }
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
