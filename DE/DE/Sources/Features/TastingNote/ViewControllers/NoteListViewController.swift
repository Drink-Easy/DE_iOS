// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit
import Moya
import Then
import CoreModule

public class NoteListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TastingNoteModel.dummy().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    private let myTastingNote = MyTastingNoteView()
    
    public override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(hex: "F8F8FA")
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupAction()
    }
    
    func setupUI() {
        view.addSubview(noteListView)
        noteListView.updateTotalWineCount(count: wineCount)
        noteListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(wineImageStackView)
        wineImageStackView.snp.makeConstraints { make in
            make.top.equalTo(noteListView.snp.bottom).offset(24)
            make.leading.equalTo(noteListView.snp.leading).offset(24)
            make.centerX.equalTo(noteListView.snp.centerX)
        }
        
        view.addSubview(myTastingNote)
        myTastingNote.snp.makeConstraints { make in
            make.top.equalTo(wineImageStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupDelegate() {
        myTastingNote.collectionView.dataSource = self
        myTastingNote.collectionView.delegate = self
    }
    
    func setupAction() {
        myTastingNote.writeButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    @objc func nextVC() {
        let nextVC = WineSearchMainVC()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
