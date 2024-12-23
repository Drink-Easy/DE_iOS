// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then

class WineDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        
        addView()
        constraints()
    }
    
    private lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addView() {
        [topNameView, wineDetailView, vivinoRateView, averageTastingNoteView, reviewView].forEach{ view.addSubview($0) }
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
        
        vivinoRateView.snp.makeConstraints {
            $0.top.equalTo(wineDetailView.snp.bottom).offset(56)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        averageTastingNoteView.snp.makeConstraints { 
            $0.top.equalTo(vivinoRateView.snp.bottom).offset(70)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}

extension WineDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 82) // 셀 크기
    }
}
