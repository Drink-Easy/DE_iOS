//// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

public class AllTastingNoteVC: UIViewController {
    
    private let networkService = TastingNoteService()
    
    private let tastingNoteView = AllTastingNoteView()
    
    var allTastingNoteList: [TastingNotePreviewResponseDTO] = []
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func loadView() {
        self.view = tastingNoteView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        Task {
            do {
                try await CallAllTastingNote()
                
            } catch {
                print("Error: \(error)")
                // Alert 표시 등 추가
            }
        }
        
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        tastingNoteView.TastingNoteCollectionView.dataSource = self
        tastingNoteView.TastingNoteCollectionView.delegate = self
    }
    
    private func CallAllTastingNote() async throws {
        
        let data = try await networkService.fetchAllNotes(sort: "전체")
        // Call Count 업데이트
        //        await self.updateCallCount()
        allTastingNoteList = data.notePriviewList
        tastingNoteView.wineImageStackView.updateCounts(red: data.sortCount.redCount, white: data.sortCount.whiteCount, sparkling: data.sortCount.sparklingCount, rose: data.sortCount.roseCount, etc: data.sortCount.etcCount)
        tastingNoteView.TastingNoteCollectionView.reloadData()
    }
    
    func updateCallCount() async {
        //        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
        //            print("⚠️ userId가 UserDefaults에 없습니다.")
        //            return
        //        }
        //        Task {
        //            // patch count + 1
        //            do {
        //                try await APICallCounterManager.shared.incrementPatch(for: userId, controllerName: .tastingNote)
        //            } catch {
        //                print(error)
        //            }
        //
        //        }
    }
    
    func didTapSortButton(for type: WineSortType) {
        let sortType: String
        switch type {
        case .all:
            sortType = "전체"
        case .red:
            sortType = "레드"
        case .white:
            sortType = "화이트"
        case .sparkling:
            sortType = "스파클링"
        case .rose:
            sortType = "로제"
        case .etc:
            sortType = "기타"
        }
        
        print("\(sortType) Tapped!!!!!!!!!!!!!!!!!!!!!!")
        
    }
    
    private func filterPieces(for type: WineSortType) -> [TastingNotePreviewResponseDTO] {
        if type == .red {
            return allTastingNoteList
        } else {
            return allTastingNoteList.filter { item in
                switch type {
                case .red:
                    return item.sort == "레드"
                case .white:
                    return item.sort == "화이트"
                case .sparkling:
                    return item.sort == "스파클링"
                case .rose:
                    return item.sort == "로제"
                default:
                    return false
                    //                    return item.sort == "기"
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AllTastingNoteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTastingNoteList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TastingNoteCollectionViewCell", for: indexPath) as? TastingNoteCollectionViewCell else {
            fatalError("Unable to dequeue TastingNoteCollectionViewCell")
        }
        
        let tnItem = allTastingNoteList[indexPath.row]
        if let url = URL(string: tnItem.imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                }
            }
        }
        cell.name.text = tnItem.wineName
        return cell
    }
}


//
//func didTapSortButton(for type: WineSortType) {
//        let sortType: String
//        switch type {
//
//        //TODO: 수정 뷰컨 연결
//        case .red:
//            sortType = "레드"
//        case .white:
//            sortType = "화이트"
//        case .sparkling:
//            sortType = "스파클링"
//        case .rose:
//            sortType = "로제"
//        case .etc:
//            sortType = "기타"
//        }
//
//    }
