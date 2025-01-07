// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import Network

class HomeEntireReviewViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    var wineId: Int = 0
    var wineName: String = ""
    var reviewResults: [WineReviewModel] = []
    let networkService = WineService()
    private var expandedCells: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG

        addView()
        constraints()
        callEntireReviewAPI(wineId: self.wineId, orderByLatest: true)
        setupDropdownAction()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupNavigationBar() {
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var largeTitleLabel = UILabel().then {
        $0.text = wineName
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.textColor = AppColor.black
    }

    private lazy var entireReviewView = EntireReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
    }
    
    private func addView() {
        [largeTitleLabel, entireReviewView].forEach{ view.addSubview($0) }
    }
    
    private func constraints() {
        largeTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        entireReviewView.snp.makeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupDropdownAction() {
        entireReviewView.dropdownView.onOptionSelected = { [weak self] selectedOption in
            guard let self = self else { return }
            if selectedOption == "최신 순" {
                self.reviewResults.sort { $0.createdAt > $1.createdAt }
            } else if selectedOption == "오래된 순" {
                self.reviewResults.sort { $0.createdAt < $1.createdAt }
            } else if selectedOption == "별점 높은 순" {
                self.reviewResults.sort { $0.rating > $1.rating }
            } else if selectedOption == "별점 낮은 순" {
                self.reviewResults.sort { $0.rating < $1.rating }
            }
            self.entireReviewView.reviewCollectionView.reloadData()
        }
    }
    
    func callEntireReviewAPI(wineId: Int, orderByLatest: Bool) {
        networkService.fetchWineReviews(wineId: wineId, orderByLatest: orderByLatest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.reviewResults = response?.compactMap { data in
                        guard let name = data.name,
                              let review = data.review,
                              let rating = data.rating,
                              let createdAt = data.createdAt else {
                            print("작성된 리뷰가 없습니다.")
                            return nil
                        }
                        return WineReviewModel(name: name, contents: review, rating: rating, createdAt: createdAt)
                    } ?? []
                    self.entireReviewView.reviewCollectionView.reloadData()
                    self.expandedCells = Array(repeating: false, count: self.reviewResults.count)
                }
            case .failure(let error):
                print("Error fetching reviews: \(error)")
            }
        }
    }
}

extension HomeEntireReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        // 텍스트 높이 계산 + 패딩
        let labelFont = UIFont.ptdMediumFont(ofSize: 14)
        let lineSpacing = labelFont.pointSize * 0.3
        let labelWidth = width - 30
        //let estimatedHeight = text.heightWithConstrainedWidth(width: labelWidth, font: labelFont)
        let numberOfLines = text.numberOfLines(width: labelWidth, font: labelFont, lineSpacing: lineSpacing)
        let lineHeight = labelFont.lineHeight + lineSpacing
        
        let cellHeight = isExpanded
                ? CGFloat(numberOfLines - 2) * lineHeight + 104
                : 104
        return CGSize(width: width, height: cellHeight)
    }
}
