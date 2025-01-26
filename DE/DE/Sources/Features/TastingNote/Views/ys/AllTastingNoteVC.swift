// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

public class AllTastingNoteVC: UIViewController, WineSortDelegate {
    
    private let networkService = TastingNoteService()
    
    private var allTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 전체 데이터
    private var currentTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 필터링된 데이터
    
    private let tastingNoteView = AllTastingNoteView()
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        setupCollectionView()
        tastingNoteView.searchButton.addTarget(self, action: #selector(noteSearchTapped), for: .touchUpInside)
        tastingNoteView.floatingButton.addTarget(self, action: #selector(newNoteTapped), for: .touchUpInside)
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
    private func setupUI() {
        tastingNoteView.wineImageStackView.delegate = self
        view.addSubview(tastingNoteView)
        tastingNoteView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func setupCollectionView() {
        tastingNoteView.TastingNoteCollectionView.dataSource = self
        tastingNoteView.TastingNoteCollectionView.delegate = self
    }
    
    private func CallAllTastingNote() async throws {
        
        let data = try await networkService.fetchAllNotes(sort: "전체")
        // Call Count 업데이트
        //        await self.updateCallCount()
        allTastingNoteList = data.notePriviewList
        currentTastingNoteList = data.notePriviewList
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
    
    //와인 이미지 스택 뷰 필터
    func didTapSortButton(for type: WineSortType) {
        // 필터링된 데이터 가져오기
        let filteredList = filterPieces(for: type)
        
        // 필터링된 데이터를 컬렉션 뷰와 동기화
        currentTastingNoteList = filteredList
        tastingNoteView.TastingNoteCollectionView.reloadData()
    }

    private func filterPieces(for type: WineSortType) -> [TastingNotePreviewResponseDTO] {
        // `전체` 타입 선택 시 모든 데이터를 반환
        guard type != .all else { return allTastingNoteList }
        
        // 타입별로 필터링
        return allTastingNoteList.filter { item in
            switch type {
            case .red: return item.sort == "레드"
            case .white: return item.sort == "화이트"
            case .sparkling: return item.sort == "스파클링"
            case .rose: return item.sort == "로제"
            case .etc:
                        return item.sort != "레드" &&
                               item.sort != "화이트" &&
                               item.sort != "스파클링" &&
                               item.sort != "로제"
            default: return false
            }
        }
    }
    
    //MARK: Setup Actions
    @objc func newNoteTapped(){
        let newVC = WineTastingNoteVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func noteSearchTapped(){
        let searchVC = SearchWineViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AllTastingNoteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WineTastingNoteVC()
        vc.noteId = currentTastingNoteList[indexPath.row].noteId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTastingNoteList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TastingNoteCollectionViewCell", for: indexPath) as? TastingNoteCollectionViewCell else {
            fatalError("Unable to dequeue TastingNoteCollectionViewCell")
        }
        
        let tnItem = currentTastingNoteList[indexPath.row]
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
