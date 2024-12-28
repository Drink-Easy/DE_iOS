// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import Network

class EntireReviewViewController: UIViewController {
    
    var wineId: Int = 0
    var wineName: String = ""
    var reviewResults: [WineReviewModel] = []
    let networkService = WineService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        
        addView()
        constraints()
        callEntireReviewAPI(wineId: self.wineId, orderByLatest: true)
    }
    
    private lazy var topNameView = TopNameView().then {
        $0.name.text = self.wineName
        $0.backBtn.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
    }
    
    @objc
    private func goToBack() {
        navigationController?.popViewController(animated: true)
    }

    private lazy var entireReviewView = EntireReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
    }
    
    private func addView() {
        [topNameView, entireReviewView].forEach{ view.addSubview($0) }
    }
    
    private func constraints() {
        topNameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        entireReviewView.snp.makeConstraints {
            $0.top.equalTo(topNameView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
                }
            case .failure(let error):
                print("Error fetching reviews: \(error)")
            }
        }
    }

}

extension EntireReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let review = reviewResults[indexPath.row]
        cell.configure(model: review)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 82) // 셀 크기
    }
}

