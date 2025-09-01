// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then

import CoreModule
import DesignSystem
import Network

class EntireReviewViewController: UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.entireReviewVC
    
    let navigationBarManager = NavigationBarManager()
    
    var wineId: Int = 0
    var wineName: String = ""
    var vintage: Int? = nil
    
    var reviewResults: [WineReviewModel] = []
    let networkService = WineService()
    private let errorHandler = NetworkErrorHandler()
    private var expandedCells: [Bool] = []
    var isLoading = false
    var currentPage = 0
    var totalPage = 0
    var currentType = "최신순"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        addView()
        constraints()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        view.addSubview(indicator)
        view.showColorBlockingView()
        setupDropdownAction()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
        
        Task {
            do {
                try await callEntireReviewAPI(wineId: self.wineId, sortType: "최신순", page: 0)
                self.view.hideBlockingView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private let largeTitleLabel = UILabel()

    private lazy var entireReviewView = EntireReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
    }
    
    private func addView() {
        view.addSubviews(largeTitleLabel, entireReviewView)
        
        var displayText = wineName
        if let vintage = vintage {
            displayText += " \(vintage)"
        }
        largeTitleLabel.numberOfLines = 0
        largeTitleLabel.lineBreakMode = .byCharWrapping

        AppTextStyle.KR.body1.apply(to: largeTitleLabel, text: displayText, color: AppColor.gray70)
    }
    
    private func constraints() {
        largeTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        entireReviewView.snp.makeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupDropdownAction() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.dropdownBtnTapped, fileName: #file)
        entireReviewView.dropdownView.onOptionSelected = { [weak self] selectedOption in
            guard let self = self else { return }
            if selectedOption == "최신 순" {
                currentType = "최신순"
            } else if selectedOption == "오래된 순" {
                currentType = "오래된 순"
            } else if selectedOption == "별점 높은 순" {
                currentType = "별점 높은 순"
            } else if selectedOption == "별점 낮은 순" {
                currentType = "별점 낮은 순"
            }
            self.view.showBlockingView()
            Task {
                do {
                    try await self.callEntireReviewAPI(wineId: self.wineId, sortType: self.currentType, page: 0)
                    DispatchQueue.main.async {
                        // 강제로 맨위로 올리기
                        self.entireReviewView.reviewCollectionView.setContentOffset(.zero, animated: true)
                    }
                    self.view.hideBlockingView()
                } catch {
                    self.view.hideBlockingView()
                    self.errorHandler.handleNetworkError(error, in: self)
                }
            }
        }
    }
    
    func callEntireReviewAPI(wineId: Int, sortType: String, page: Int, vintage: Int? = nil) async throws {
        guard let response = try await networkService.fetchWineReviews(wineId: wineId, vintageYear: vintage, sortType: sortType, page: page) else {
            return
        }
        
        guard let content = response.content else { return }
        // reponse 와인 10개 매핑해주고
        let nextReviewDatas: [WineReviewModel] = content.compactMap { data in
            guard let name = data.name,
                  let review = data.review,
                  let rating = data.rating,
                  let createdAt = data.createdAt else {
                return nil
            }
            return WineReviewModel(name: name, contents: review, rating: rating, createdAt: createdAt)
        }
        
        if response.pageNumber != 0 { // 맨 처음 요청한게 아니면, 이전 데이터가 이미 저장이 되어있는 상황이면
            // 리스트 뒤에다가 넣어준다!
            self.currentPage = response.pageNumber
            self.reviewResults.append(contentsOf: nextReviewDatas)
            self.expandedCells.append(contentsOf: Array(repeating: false, count: nextReviewDatas.count))
        } else {
            // 토탈 페이지 수 갱신, 현재 페이지 수 설정
            self.totalPage = response.totalPages
            self.currentPage = response.pageNumber
            self.reviewResults = nextReviewDatas
            self.expandedCells = Array(repeating: false, count: nextReviewDatas.count)
        }
        DispatchQueue.main.async {
            self.entireReviewView.reviewCollectionView.reloadData()
        }
    }
}

extension EntireReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let review = reviewResults[indexPath.item]
        cell.configure(model: review, isExpanded: expandedCells[indexPath.item])
        
        cell.onToggle = {
            self.expandedCells[indexPath.item].toggle()
            
            UIView.animate(withDuration: 0, animations: {
                collectionView.performBatchUpdates(nil, completion: nil)
            }) { _ in
                // 텍스트를 약간 늦춰서 줄이기
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cell.review.numberOfLines = self.expandedCells[indexPath.item] ? 0 : 2
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let text = reviewResults[indexPath.item].contents
        let isExpanded = expandedCells[indexPath.item]
        
        let labelFont = UIFont.pretendard(.medium, size: 14)
        let lineSpacing = labelFont.pointSize * 0.3
        let labelWidth = width - 30
        let lineHeight = labelFont.lineHeight + lineSpacing
        
        let numberOfLines = text.numberOfLines(width: labelWidth, font: labelFont, lineSpacing: lineSpacing)
        let isTruncated = numberOfLines > 2
        
        let baseHeight: CGFloat = 98
        let toggleButtonExtraHeight: CGFloat = 13 + 12  // spacing + button + bottom inset
        
        let height: CGFloat
        if isExpanded {
            // 전체 줄 다 보여줄 때
            height = CGFloat(numberOfLines) * lineHeight + (baseHeight - (2 * lineHeight)) + toggleButtonExtraHeight
        } else {
            // 접힌 상태. 줄 수가 2를 초과하면 toggleButton을 위한 여유 공간 확보
            height = baseHeight + (isTruncated ? toggleButtonExtraHeight : 0)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0 // 위쪽 바운스 막기
        }
        
        guard scrollView is UICollectionView else { return }
        
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
                    try await callEntireReviewAPI(wineId: self.wineId, sortType: currentType, page: currentPage + 1)
                    self.view.hideBlockingView()
                } catch {
                    self.view.hideBlockingView()
                    errorHandler.handleNetworkError(error, in: self)
                }
                DispatchQueue.main.async {
                    self.entireReviewView.reviewCollectionView.reloadData()
                }
                isLoading = false
            }
        }
    }
}

