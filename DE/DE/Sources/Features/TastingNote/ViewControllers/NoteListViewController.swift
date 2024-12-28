// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit
import Moya
import Then
import CoreModule
import Network

public class NoteListViewController: UIViewController {
    
    var wineCount: Int = 0
    
    // Source -> cells -> TastingNote
    private let noteListView = NoteListView()
    // Source -> cells -> TastingNote
    private let wineImageStackView = WineImageStackView()
    private let myTastingNote = MyTastingNoteView()
    
    let noteService = TastingNoteService()
    
    /*func callGet() {
        noteService.fetchAllNotes(sort: <#T##String#>, completion: <#T##(Result<AllTastingNoteResponseDTO, NetworkError>) -> Void#>)
    }*/
    
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
        navigationController?.pushViewController(nextVC, animated: true)
    }

}

extension NoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
}
