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
    
    let flowersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.clipsToBounds = false
        $0.tag = 0
    }
    
    let fruitsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 1
    }
    
    let vegetablesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 2
    }
    
    let spicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 3
    }
    
    let chemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 4
    }
    
    let animalsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 5
    }
    
    let burnsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //.init(width: 89, height: 41)
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 10
    }).then {
        $0.backgroundColor = .clear
        $0.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        $0.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifer)
        $0.tag = 6
    }
    
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
        
        contentView.addSubview(flowersCollectionView)
        flowersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(noseDescription.snp.bottom).offset(50)
            make.leading.equalTo(noseDescription)
            make.centerX.equalTo(vector1.snp.centerX)
            make.height.equalTo(142)
        }
        
        contentView.addSubview(fruitsCollectionView)
        fruitsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(flowersCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(flowersCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(vegetablesCollectionView)
        vegetablesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fruitsCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(fruitsCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(spicesCollectionView)
        spicesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(vegetablesCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(vegetablesCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(chemsCollectionView)
        chemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(spicesCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(spicesCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(animalsCollectionView)
        animalsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chemsCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(chemsCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(burnsCollectionView)
        burnsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(animalsCollectionView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(animalsCollectionView)
            make.height.equalTo(143)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(burnsCollectionView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(56)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(20)
        }
        
    }

    
}
