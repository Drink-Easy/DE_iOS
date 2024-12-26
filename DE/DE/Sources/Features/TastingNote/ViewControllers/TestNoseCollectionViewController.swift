// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class TestNoseCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var sections: [NoseSectionModel] = NoseSectionModel.sections() // 섹션 데이터

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() // CollectionView 설정
    }
    
    private func setupCollectionView() {
        // 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 60) / 2, height: 50) // 셀 크기 설정 (2열 구성)
        layout.minimumInteritemSpacing = 10 // 셀 간격
        layout.minimumLineSpacing = 10 // 행 간격
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50) // 헤더 크기
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        // 셀 및 헤더 등록
        collectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        collectionView.register(NoseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        // 콜렉션뷰 자체의 위치 설정
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension TestNoseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션 수
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // 각 섹션의 아이템 수 - 접혀있으면 0으로 고정해버림
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].isExpanded ? sections[section].items.count : 0
    }
    
    // 셀 설정
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as? NoseCollectionViewCell else {
            fatalError("셀 등록 실패")
        }
        
        // 데이터 바인딩
        let item = sections[indexPath.section].items[indexPath.item]
        cell.menuLabel.text = item.type
        
        return cell
    }
    
    // 헤더 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as! NoseHeaderView
        
        let section = sections[indexPath.section]
        // 상태(isExpanded) 전달 - 헤더 configure 함수 호출
        header.configure(with: section.sectionTitle, section: indexPath.section, delegate: self, isExpanded: section.isExpanded)
        return header
    }
}

extension TestNoseCollectionViewController: NoseHeaderViewDelegate {
    // 토글 애니메이션에 대한 것
    func toggleSection(_ section: Int) {
        sections[section].isExpanded.toggle()
        
        // 애니메이션 적용
        let indexSet = IndexSet(integer: section)
        collectionView.performBatchUpdates({
            collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
}


protocol NoseHeaderViewDelegate: AnyObject {
    func toggleSection(_ section: Int) // 섹션 상태 토글을 위한 델리게이트 메서드
}

class NoseHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    weak var delegate: NoseHeaderViewDelegate? // 델리게이트 선언
    private var section: Int = 0 // 섹션 번호 저장
    
    // 타이틀 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // 화살표 아이콘 - 열려있을 떄만 보이게. 기본 값이 안보기에
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down") // 시스템 아이콘
        imageView.tintColor = .black
        imageView.isHidden = true // 기본 상태에서 숨김 처리
        return imageView
    }()
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // UI 설정
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped))) // 터치 제스처 추가
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            // TODO : 레이아웃 피그마랑 똑같에 맞추기
            make.leading.equalTo(titleLabel.snp.trailing).offset(16) // titleLabel 옆 16포인트 간격(이건 피그마보고 조정해야할듯? 임시로 해놓은 것)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20) // 아이콘 크기 20x20
        }
    }
    
    // MARK: - 데이터 설정
    func configure(with title: String, section: Int, delegate: NoseHeaderViewDelegate, isExpanded: Bool) {
        titleLabel.text = title
        self.section = section
        self.delegate = delegate
        
        iconImageView.isHidden = !isExpanded
    }
    
    // MARK: - 액션 처리
    @objc private func headerTapped() {
        delegate?.toggleSection(section) // 섹션 토글 메서드 호출
    }
}
