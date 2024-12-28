//
//  ChooseNoseView.swift
//  Drink-EG
//
//  Created by 이수현 on 12/17/24.
//

import UIKit
import CoreModule
import SnapKit

// 계열 선택 뷰
class ChooseNoseView: UIView {

    var flowersCollectionViewHeightConstraint: Constraint? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColor.gray20
        return cv
    }()
    
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
    
    let navView: CustomNavigationBar = {
        let n = CustomNavigationBar()
        n.backgroundColor = AppColor.gray20
        return n
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
        w.text = "루이 로드레 크리스탈 2015"
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
        n.numberOfLines = 0
        return n
    }()
    
    let nextButton: UIButton = {
        let n = UIButton()
        n.setTitle("다음", for: .normal)
        n.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 18)
        n.backgroundColor = UIColor(hex: "#7E13B1")
        n.layer.cornerRadius = 14
        n.setTitleColor(.white, for: .normal)
        return n
    }()
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(navView)
        navView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
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
            make.leading.equalTo(vector1)
            make.trailing.equalTo(vector1.snp.trailing).offset(-37)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(noseDescription.snp.bottom).offset(24)
            make.leading.equalTo(noseDescription.snp.leading).offset(6)
            make.centerX.equalTo(vector1.snp.centerX)
            make.height.equalTo(700)
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

    
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes.forEach { layoutAttribute in
            // 헤더와 푸터는 정렬 대상에서 제외
            if layoutAttribute.representedElementCategory == .cell {
                // 같은 행인지 확인
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}
