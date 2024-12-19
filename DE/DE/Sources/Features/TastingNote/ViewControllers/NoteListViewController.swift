//
//  NoteListViewController.swift
//  Drink-EG
//
//  Created by 김도연 on 7/21/24.
//

import Foundation
import UIKit
import SnapKit
import Moya
import Then

class NoteListViewController: UIViewController, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TastingNoteModel.dummy().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let list = TastingNoteModel.dummy()
        cell.imageView.image = list[indexPath.row].images
        cell.nameLabel.text = list[indexPath.row].label
        return cell
    }
    
    
    var wineCount: Int = 0
    
    // Source -> cells -> TastingNote
    private let noteListView = NoteListView()
    // Source -> cells -> TastingNote
    private let wineImageStackView = WineImageStackView()
    private let myTastingNote = MyTastingNote()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hex: "F8F8FA")
        super.viewDidLoad()
        setupUI()
        setupDelegate()
    }
    
    func setupUI() {
        view.addSubview(noteListView)
        noteListView.updateTotalWineCount(count: wineCount)
        noteListView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(106)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(100) // 수정 필요
        }
        
        view.addSubview(wineImageStackView)
        wineImageStackView.snp.makeConstraints { make in
            make.top.equalTo(noteListView.snp.bottom).offset(24)
            make.leading.equalTo(noteListView.snp.leading)
            make.centerX.equalTo(noteListView.snp.centerX)
        }
        
        view.addSubview(myTastingNote)
        myTastingNote.snp.makeConstraints { make in
            make.top.equalTo(wineImageStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        myTastingNote.collectionView.dataSource = self
    }
    
    
    
    
}
