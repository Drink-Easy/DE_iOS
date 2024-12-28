// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network

class WineDetailViewController: UIViewController {
    
    var wineId: Int = 0
    var wineName: String = ""
    let networkService = WineService()
    var reviewData: [WineReviewModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        
        addView()
        constraints()
        callWineDetailAPI(wineId: self.wineId)
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var contentView = UIView()
    
    private lazy var topNameView = TopNameView().then {
        $0.backBtn.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
    }
    
    @objc
    private func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private var wineDetailView = WineDetailView()
    private var vivinoRateView = VivinoRateView()
    private var averageTastingNoteView = AverageTastingNoteView()
    
    private lazy var reviewView = ReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
        $0.moreBtn.addTarget(self, action: #selector(goToEntireReview), for: .touchUpInside)
    }
    
    @objc
    private func goToEntireReview() {
        let vc = EntireReviewViewController()
        vc.wineId = self.wineId
        vc.wineName = self.wineName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addView() {
        [topNameView, wineDetailView, scrollView].forEach{ view.addSubview($0) }
        scrollView.addSubview(contentView)
        [vivinoRateView, averageTastingNoteView, reviewView].forEach{ contentView.addSubview($0) }
    }
    
    private func constraints() {
        topNameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        wineDetailView.snp.makeConstraints {
            $0.top.equalTo(topNameView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(wineDetailView.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(reviewView.snp.bottom).offset(50)
        }
        
        vivinoRateView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        averageTastingNoteView.snp.makeConstraints { 
            $0.top.equalTo(vivinoRateView.snp.bottom).offset(70)
            $0.horizontalEdges.equalToSuperview()
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom).offset(55)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    func transformResponseData(_ responseData : WineResponseWithThreeReviewsDTO) {
        let wineResponse = responseData.wineResponseDTO
        self.wineId = wineResponse.wineId
        self.wineName = wineResponse.name
        let noseNotes = [
            wineResponse.wineNoteNose?.nose1 ?? "nose1",
            wineResponse.wineNoteNose?.nose2 ?? "nose2",
            wineResponse.wineNoteNose?.nose3 ?? "nose3"
        ]

        let tastingNoteString = noseNotes.joined(separator: ", ")
        
        let topData = WineDetailTopModel(isLiked: wineResponse.liked, wineName: wineResponse.name)
        let infoData = WineDetailInfoModel(image: wineResponse.imageUrl, sort: wineResponse.sort, area: wineResponse.area)
        let rateData = WineViVinoRatingModel(vivinoRating: wineResponse.vivinoRating)
        let avgData = WineAverageTastingNoteModel(wineNoseText: tastingNoteString)
        let reviewData = WineAverageReviewModel(avgMemberRating: wineResponse.avgMemberRating)
        if let reviewResponse = responseData.recentReviews {
            for data in reviewResponse {
                let review = WineReviewModel(name: data.name, contents: data.review, rating: data.rating, createdAt: data.createdAt)
                self.reviewData.append(review)
            }
        }
        DispatchQueue.main.async {
            self.topNameView.configure(topData)
            self.wineDetailView.configure(infoData)
            self.vivinoRateView.configure(rateData)
            self.averageTastingNoteView.configure(avgData)
            self.reviewView.configure(reviewData)
            self.reviewView.reviewCollectionView.reloadData()
        }
    }
    
    func callWineDetailAPI(wineId: Int) {
        networkService.fetchWineInfo(wineId: self.wineId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                self.transformResponseData(responseData)
            case .failure(let error) :
                print("\(error)")
            }
        }
    }
}

extension WineDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let review = reviewData[indexPath.row]
        cell.configure(model: review)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 82) // 셀 크기
    }
}
