// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 계열 선택 뷰
class ChangeNoseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = .clear
        return s
    }()
    
    private let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
    let pageLabel: UILabel = {
        let p = UILabel()
        p.textColor = AppColor.gray80
        let fullText = "1/5"
        let coloredText = "1"
        let attributedString = fullText.withColor(for: coloredText, color: AppColor.purple70 ?? UIColor(hex: "9741BF")!)
        p.attributedText = attributedString
        p.font = .ptdMediumFont(ofSize: 16)
        return p
    }()
    
    private let wineName: UILabel = {
        let w = UILabel()
        // w.text = "루이 로드레 크리스탈 2015"
        w.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        w.textColor = .black
        return w
    }()
    
    private let noseLabel: UILabel = {
        let n = UILabel()
        n.text = "Nose"
        n.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        n.textColor = .black
        return n
    }()
    
    private let noseLabelKorean: UILabel = {
        let n = UILabel()
        n.text = "향"
        n.font = UIFont.ptdRegularFont(ofSize: 14)
        n.textColor = UIColor(hex: "#767676")
        return n
    }()
    
    private let vector1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    private let noseDescription: UILabel = {
        let n = UILabel()
        n.text = "와인을 시음하기 전, 향을 맡아보세요! 와인 잔을 천천히 돌려 잔의 표면에 와인을 묻히면 잔 속에 향이 풍부하게 느껴져요."
        n.font = UIFont.ptdRegularFont(ofSize: 14)
        n.textColor = UIColor(hex: "#767676")
        n.lineBreakMode = .byTruncatingTail
        n.numberOfLines = 0
        return n
    }()
    
    private let selectedLabel: UILabel = {
        let s = UILabel()
        s.text = "선택된 항목"
        s.font = .ptdSemiBoldFont(ofSize: 14)
        s.textColor = AppColor.purple100
        return s
    }()
    
    let selectedCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColor.gray20
        cv.tag = 1
        return cv
    }()
    
    let collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColor.gray20
        cv.tag = 0
        return cv
    }()
    
    let nextButton: UIButton = {
        let n = UIButton()
        n.setTitle("저장하기", for: .normal)
        n.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 18)
        n.backgroundColor = UIColor(hex: "#7E13B1")
        n.layer.cornerRadius = 14
        n.setTitleColor(.white, for: .normal)
        return n
    }()
    
    func updateUI(wineName: String) {
        self.wineName.text = wineName
    }
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(2)
            make.leading.equalTo(pageLabel)
        }
        
        contentView.addSubview(noseLabel)
        noseLabel.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(38)
            make.leading.equalTo(wineName.snp.leading)
        }
        
        contentView.addSubview(noseLabelKorean)
        noseLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(noseLabel.snp.top).offset(4)
            make.leading.equalTo(noseLabel.snp.trailing).offset(8)
        }
        
        contentView.addSubview(vector1)
        vector1.snp.makeConstraints { make in
            make.top.equalTo(noseLabel.snp.bottom).offset(6)
            make.leading.equalTo(noseLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(noseDescription)
        noseDescription.snp.makeConstraints { make in
            make.top.equalTo(vector1.snp.bottom).offset(12)
            make.leading.trailing.equalTo(vector1)
            // make.trailing.equalTo(vector1.snp.trailing).offset(-37)
        }
        
        contentView.addSubview(selectedLabel)
        selectedLabel.snp.makeConstraints { make in
            make.top.equalTo(noseDescription.snp.bottom).offset(24)
            make.leading.equalTo(noseDescription.snp.leading).offset(6)
        }
        
        contentView.addSubview(selectedCollectionView)
        selectedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(6)
            make.leading.equalTo(selectedLabel.snp.leading).offset(-6)
            make.centerX.equalTo(vector1.snp.centerX)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedCollectionView.snp.bottom).offset(24)
            make.leading.equalTo(selectedCollectionView.snp.leading).offset(6)
            make.centerX.equalTo(vector1.snp.centerX)
            make.height.equalTo(400)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(56)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(20)
        }
        
    }

    func updateSelectedCollectionViewHeight() {
        selectedCollectionView.layoutIfNeeded() // 레이아웃 업데이트
        let contentHeight = selectedCollectionView.contentSize.height
        selectedCollectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
    }
    
    func updateNoseCollectionViewHeight() {
        collectionView.layoutIfNeeded() // 레이아웃 업데이트
        let contentHeight = collectionView.contentSize.height
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
    }
    
}
