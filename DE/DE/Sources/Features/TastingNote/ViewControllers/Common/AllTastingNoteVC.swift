// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

//테이스팅노트 메인 노트 보관함 뷰
public class AllTastingNoteVC: UIViewController, WineSortDelegate, UIGestureRecognizerDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.allTastingNoteVC
    
    private let networkService = TastingNoteService()
    var isLoading = false
    var currentPage = 0
    var totalPage = 0
    var currentType = "전체"
    
    private var allTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 전체 데이터
    private var currentTastingNoteList: [TastingNotePreviewResponseDTO] = [] // 필터링된 데이터
    
    private let tastingNoteView = AllTastingNoteView()
    
    let floatingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "pencil"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = AppColor.purple100
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
                try await CallAllTastingNote(sort: "전체", page: 0)
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
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
    
    private func CallAllTastingNote(sort: String, page: Int) async throws {
        
        let response = try await networkService.fetchAllNotes(sort: sort, page: page)
        
        if response.pageResponse.pageNumber != 0 { // 맨 처음 요청한게 아니면, 이전 데이터가 이미 저장이 되어있는 상황이면
            // 리스트 뒤에다가 넣어준다!
            self.currentPage = response.pageResponse.pageNumber
            //self.allTastingNoteList.append(contentsOf: response.pageResponse.content)
            self.currentTastingNoteList.append(contentsOf: response.pageResponse.content)
        } else {
            // 토탈 페이지 수 갱신, 현재 페이지 수 설정
            self.totalPage = response.pageResponse.totalPages
            self.currentPage = response.pageResponse.pageNumber
            //self.allTastingNoteList = response.pageResponse.content
            self.currentTastingNoteList = response.pageResponse.content
        }
    
        // 데이터 없을 때 콜렉션 뷰 숨기고 없음 라벨
        tastingNoteView.noTastingNoteLabel.isHidden = !self.currentTastingNoteList.isEmpty
        tastingNoteView.TastingNoteCollectionView.isHidden = self.currentTastingNoteList.isEmpty
        
        tastingNoteView.wineImageStackView.updateCounts(red: response.sortCount.redCount, white: response.sortCount.whiteCount, sparkling: response.sortCount.sparklingCount, rose: response.sortCount.roseCount, etc: response.sortCount.etcCount)
        
        DispatchQueue.main.async {
            self.tastingNoteView.TastingNoteCollectionView.reloadData()
        }
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
        currentType = type.rawValue
        self.view.showBlockingView()
        Task {
            do {
                try await CallAllTastingNote(sort: currentType, page: 0)
                DispatchQueue.main.async {
                    // ✅ UI 업데이트는 메인 스레드에서 실행
                    self.tastingNoteView.noTastingNoteLabel.isHidden = !self.currentTastingNoteList.isEmpty
                    self.tastingNoteView.TastingNoteCollectionView.isHidden = self.currentTastingNoteList.isEmpty
                    // ✅ 목록을 맨 위로 스크롤
                    self.tastingNoteView.TastingNoteCollectionView.setContentOffset(.zero, animated: true)
                }
                self.view.hideBlockingView()
            } catch {
                print("Error: \(error)")
                self.view.hideBlockingView()
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
extension AllTastingNoteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0 // 위쪽 바운스 막기
        }
        
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Check if user has scrolled to the bottom
        if contentOffsetY > contentHeight - scrollViewHeight { // Trigger when arrive the bottom
            guard !isLoading, currentPage + 1 < totalPage else { return }
            isLoading = true
            self.view.showBlockingView()
            Task {
                do {
                    try await CallAllTastingNote(sort: currentType, page: currentPage + 1)
                    self.view.hideBlockingView()
                } catch {
                    print("Failed to fetch next page: \(error)")
                    self.view.hideBlockingView()
                }
                DispatchQueue.main.async {
                    self.tastingNoteView.TastingNoteCollectionView.reloadData()
                }
                isLoading = false
            }
        }
    }
}
