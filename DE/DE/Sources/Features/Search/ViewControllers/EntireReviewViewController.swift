// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule

class EntireReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        
        addView()
        constraints()
    }
    
    private lazy var topNameView = TopNameView().then {
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

}

extension EntireReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 82) // 셀 크기
    }
}

