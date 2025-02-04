// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

//테이스팅노트 메인 노트 보관함 뷰
public class AllTastingNoteVC: UIViewController, WineSortDelegate, UIGestureRecognizerDelegate {
    
    private let networkService = TastingNoteService()
    
    private var allTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 전체 데이터
    private var currentTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 필터링된 데이터
    
    private let tastingNoteView = AllTastingNoteView()
    
    let floatingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "pencil"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = AppColor.purple70
        $0.layer.cornerRadius = DynamicPadding.dynamicValue(25.0)
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.layer.masksToBounds = false
    }
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        tastingNoteView.noTastingNoteLabel.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        Task {
            do {
                self.view.showBlockingView()
                try await CallAllTastingNote()
                self.view.hideBlockingView()
            } catch {
                print("Error: \(error)")
                self.view.hideBlockingView()
                // Alert 표시 등 추가
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        view.backgroundColor = AppColor.bgGray
        setupCollectionView()
        tastingNoteView.searchButton.addTarget(self, action: #selector(noteSearchTapped), for: .touchUpInside)
        floatingButton.addTarget(self, action: #selector(newNoteTapped), for: .touchUpInside)
        
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        tastingNoteView.wineImageStackView.delegate = self
        view.addSubview(tastingNoteView)
        view.addSubview(floatingButton)
        tastingNoteView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(DynamicPadding.dynamicValue(50.0))
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
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
        // 데이터 없을 때 콜렉션 뷰 숨기고 없음 라벨
        tastingNoteView.noTastingNoteLabel.isHidden = !self.allTastingNoteList.isEmpty
        tastingNoteView.TastingNoteCollectionView.isHidden = self.allTastingNoteList.isEmpty
        
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
        currentTastingNoteList = filteredList
        // 필터링 데이터 없을 때 콜렉션 뷰 숨기고 없음 라벨
        tastingNoteView.noTastingNoteLabel.isHidden = !self.currentTastingNoteList.isEmpty
        tastingNoteView.TastingNoteCollectionView.isHidden = self.currentTastingNoteList.isEmpty
        // 필터링된 데이터를 컬렉션 뷰와 동기화
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
        let newVC = SearchWineViewController()
        newVC.hidesBottomBarWhenPushed = true
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
        vc.wineName = currentTastingNoteList[indexPath.row].wineName
        vc.hidesBottomBarWhenPushed = true
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
        cell.configure(name: tnItem.wineName, imageURL: tnItem.imageUrl)
        return cell
    }
}
