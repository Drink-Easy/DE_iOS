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
    private var allNotesData: AllTastingNoteResponseDTO?
    private var notePreviewList: [TastingNotePreviewResponseDTO] = []
    
    // Source -> cells -> TastingNote
    private let noteListView = NoteListView()
    // Source -> cells -> TastingNote
    private let wineImageStackView = WineImageStackView()
    private let myTastingNote = MyTastingNoteView()
    
    let noteService = TastingNoteService()
    
    func callAllNote() {
        noteService.fetchAllNotes(sort: "all", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                if let data = data {
                    handleResponse(data)
                } else {
                    print("Optional Error")
                }
                
            case.failure(let error):
                print(error)
            }
        })
    }
    
    func callSelectedNote(noteId: Int) {
        print("NoteID \(noteId)")
        noteService.fetchNote(noteId: noteId, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                handleSelectedNoteResponse(data)
            case.failure(let error):
                print(error)
            }
        })
    }
    
    public override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(hex: "F8F8FA")
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupAction()
        callAllNote()
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
        wineImageStackView.delegate = self
    }
    
    func setupAction() {
        myTastingNote.writeButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        noteListView.seeAllLabel.addGestureRecognizer(tapGesture)
    }
    
    private func handleResponse(_ data: AllTastingNoteResponseDTO) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 데이터 저장
            self.allNotesData = data
            self.notePreviewList = data.notePriviewList
            
            // WineImageStackView 업데이트
            self.wineImageStackView.updateCounts(
                red: data.red,
                white: data.white,
                sparkling: data.sparkling,
                rose: data.rose,
                etc: data.etc
            )
            
            // Total Wine Count 업데이트
            self.noteListView.updateTotalWineCount(count: data.total)
            
            // MyTastingNoteView 컬렉션 뷰 업데이트
            self.myTastingNote.collectionView.reloadData()
        }
    }
    
    private func handleSelectedNoteResponse(_ data: TastingNoteResponsesDTO) {
        DispatchQueue.main.async {
            print("Fetched Note Data:", data)
            
            let infoVC = WineInfoViewController()
            self.navigationController?.pushViewController(infoVC, animated: true)
        }
    }
    
    @objc func nextVC() {
        let nextVC = WineSearchMainVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func labelTapped() {
        callAllNote()
    }
    
}

extension NoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notePreviewList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let note = notePreviewList[indexPath.row]
        
        cell.imageView.sd_setImage(
            with: URL(string: note.imageUrl),
            placeholderImage: UIImage(named: "placeholder"), // 로드 중 보여줄 기본 이미지
            options: .highPriority, // 우선순위 높은 옵션
            completed: nil
        )
        
        cell.nameLabel.text = note.wineName
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNote = notePreviewList[indexPath.row]
        callSelectedNote(noteId: selectedNote.noteId)
    }
    
}

extension NoteListViewController: WineImageStackViewDelegate {
    func didSelectWineSort(sort: String) {
        guard let wineSort = WineSort.toKorean(sort) else {
            print("Error")
            return
        }
        noteService.fetchAllNotes(sort: wineSort.rawValue, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                if let data = data {
                    handleResponse(data)
                } else {
                    print("Optional Error")
                }
            case.failure(let error):
                print(error)
            }
        })
    }
}

extension NoteListViewController: MyTastingNoteViewDelegate {
    func didTapTastingNoteLabel() {
        
    }
}
