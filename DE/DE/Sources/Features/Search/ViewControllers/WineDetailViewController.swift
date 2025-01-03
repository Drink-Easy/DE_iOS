// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network

class WineDetailViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    var wineId: Int = 0
    var wineName: String = ""
    let networkService = WineService()
    var reviewData: [WineReviewModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .foregroundColor: AppColor.black!
        ]
        view.backgroundColor = Constants.AppColor.grayBG
        
        addView()
        constraints()
        callWineDetailAPI(wineId: self.wineId)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.title = wineName
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray70!
        )
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "heart",
            target: self,
            action: #selector(tappedLiked),
            tintColor: AppColor.purple100!
        )
        
//        navigationBarManager.setTitle(
//            to: navigationItem,
//            title: wineName,
//            textColor: AppColor.black!
//        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedLiked(_ sender: UIButton) {
        sender.isSelected.toggle()
            
        // 버튼이 클릭될 때마다, 버튼 이미지를 변환
        if sender.isSelected {
            let heartFilledImage = UIImage(systemName: "heart.fill")?.withTintColor(AppColor.purple100!, renderingMode: .alwaysOriginal)
            sender.setImage(heartFilledImage, for: .selected)
            sender.tintColor = AppColor.bgGray
        } else {
            let heartImage = UIImage(systemName: "heart")?.withTintColor(AppColor.purple100!, renderingMode: .alwaysOriginal)
            sender.setImage(heartImage, for: .normal)
            sender.tintColor = AppColor.bgGray
        }
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var contentView = UIView()
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [wineDetailView, vivinoRateView, averageTastingNoteView, reviewView].forEach{ contentView.addSubview($0) }
    }
    
    private func constraints() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(reviewView.snp.bottom).offset(40)
        }
        
        wineDetailView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        vivinoRateView.snp.makeConstraints {
            $0.top.equalTo(wineDetailView.snp.bottom).offset(54)
            $0.horizontalEdges.equalToSuperview()
        }
        
        averageTastingNoteView.snp.makeConstraints { 
            $0.top.equalTo(vivinoRateView.snp.bottom).offset(70)
            $0.horizontalEdges.equalToSuperview()
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom).offset(55)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
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
        
        DispatchQueue.main.async {
            self.setupNavigationBar() // 제목 설정
        }
        
        //let topData = WineDetailTopModel(isLiked: wineResponse.liked, wineName: wineResponse.name)
        let infoData = WineDetailInfoModel(image: wineResponse.imageUrl, sort: wineResponse.sort, area: wineResponse.area)
        let rateData = WineViVinoRatingModel(vivinoRating: wineResponse.vivinoRating)
        let avgData = WineAverageTastingNoteModel(wineNoseText: tastingNoteString)
        let reviewData = WineAverageReviewModel(avgMemberRating: wineResponse.avgMemberRating)
        if let reviewResponse = responseData.recentReviews {
            for data in reviewResponse {
                if let name = data.name,
                       let review = data.review,
                   let rating = data.rating,
                   let createdAt = data.createdAt {
                    let reviewModel = WineReviewModel(name: name, contents: review, rating: rating, createdAt: createdAt)
                    self.reviewData.append(reviewModel)
                } else {
                    print("작성된 리뷰가 없습니다.")
                }
            }
        }
        DispatchQueue.main.async {
            //self.topNameView.configure(topData)
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
                if let data = responseData {
                    self.transformResponseData(data)
                }
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
