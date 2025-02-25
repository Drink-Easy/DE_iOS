// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

class EditNoseViewController: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    var screenName: String = Tracking.VC.editNoseVC

    let wineData = TNWineDataManager.shared
    let tnManager = NewTastingNoteManager.shared
    private let errorHandler = NetworkErrorHandler()
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let topView = NoseTopView() // 기본 상단 뷰
    let middleView = NoseBottomView(title: "저장하기", isEnabled: false) // 중간 뷰
//    let middleView = OnlyScrollView()
    let navigationBarManager = NavigationBarManager()
    let networkService = TastingNoteService()
    var scentNames: [String] = []
    private var smallTitleLabel = UILabel()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NoseManager.shared.resetSelectedScents()
        NoseManager.shared.collapseAllSections()
        
        topView.header.setTitleLabel(wineData.wineName)
        
        scentNames = tnManager.nose
        NoseManager.shared.applySelectedScents(from: scentNames)
        
        middleView.noseCollectionView.reloadData()
        topView.selectedCollectionView.reloadData()
        
        let selectedCount = NoseManager.shared.scentSections.flatMap { $0.scents }.filter { $0.isSelected }.count
        middleView.nextButton.isEnabled(isEnabled: selectedCount >= 3)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicator)
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupCollectionView()
        setupActions()
        setupNavigationBar()
        setNavBarAppearance(navigationController: self.navigationController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.topView.selectedCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.topView.updateSelectedCollectionViewHeight()
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalTo(self.middleView.snp.bottom).offset(30)
            }
            
            self.view.layoutIfNeeded() // 레이아웃 강제 업데이트
        }
    }
    
    private func setupUI() {
        topView.propertyHeader.setName(eng: "Nose", kor: "향")
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        [middleView, topView].forEach { contentView.addSubview($0) }
        
        topView.header.setTitleLabel(wineData.wineName)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(middleView.snp.bottom).offset(DynamicPadding.dynamicValue(30.0)) // 콘텐츠 끝까지 확장
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DynamicPadding.dynamicValue(10.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
        }
        
        let collectionViewContentHeight = self.middleView.noseCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        middleView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.height.greaterThanOrEqualTo(collectionViewContentHeight + DynamicPadding.dynamicValue(140.0)) // *110.0
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        // 레이아웃 설정
        let selectedCollectionView = topView.selectedCollectionView
        selectedCollectionView.tag = 1
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        topView.selectedCollectionView.allowsSelection = false
        selectedCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        
        let noseCollectionView = middleView.noseCollectionView
        noseCollectionView.tag = 0
        noseCollectionView.delegate = self
        noseCollectionView.dataSource = self
        
        noseCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        noseCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifier)

    }
    
    private func setupActions() {
        middleView.nextButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
        
        smallTitleLabel = navigationBarManager.setNReturnTitle(
            to: navigationItem,
            title: wineData.wineName,
            textColor: AppColor.black ?? .black
        )
        smallTitleLabel.isHidden = true
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped() {
        logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.saveBtnTapped,
                       fileName: #file)
        let scents = NoseManager.shared.selectedScents

        scentNames = scents.map { $0.name }
        tnManager.saveNose(scentNames)
        callUpdateAPI()
    }
    
    private func callUpdateAPI() {
        let updateData = networkService.makeUpdateNoteBodyDTO(updateNoseList: tnManager.nose)
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        self.view.showBlockingView()
        Task {
            do {
                _ = try await networkService.patchNote(data: tnData)
                NoseManager.shared.resetAllScents()
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = topView.header.frame.maxY + 5
        
        UIView.animate(withDuration: 0.1) {
            self.topView.header.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
}

extension EditNoseViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    /// 섹션 수
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 { // noseCollectionView
            return NoseManager.shared.scentSections.count
        } else if collectionView.tag == 1 { // selectedCollectionView
            return 1
        }
        return 0
    }
    
    /// 각 섹션의 아이템 수 - 접혀있으면 0으로 고정
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if NoseManager.shared.scentSections[section].isExpand { // 열려있는 상태
                return NoseManager.shared.scentSections[section].scents.count
            } else { // 닫혀있는 상태
                return 0
            }
        } else if collectionView.tag == 1 {
//            scentNames = tnManager.nose
//            NoseManager.shared.applySelectedScents(from: scentNames)
            return NoseManager.shared.selectedScents.count
        }
        return 0
    }
    
    /// 셀에 데이터 넣어주는 함수
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as? NoseCollectionViewCell else {
            fatalError("셀 등록 실패")
        }
        
        if collectionView.tag == 0 {
            let item = NoseManager.shared.scentSections[indexPath.section].scents[indexPath.row]
            cell.menuLabel.text = item.name
            
            if item.isSelected { // 선택 항목 -> 컬러 넣어주기
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple70?.cgColor
            } else { // 선택되지 않은 항목
                cell.menuView.backgroundColor = AppColor.gray10
                cell.menuLabel.textColor = AppColor.gray100
                cell.menuView.layer.borderColor = UIColor.clear.cgColor
            }
        } else if collectionView.tag == 1 {// 선택 항목 -> 컬러 넣어주기
            let scent = NoseManager.shared.selectedScents[indexPath.row]
            cell.menuLabel.text = scent.name
            
            cell.menuView.backgroundColor = AppColor.purple10
            cell.menuLabel.textColor = AppColor.purple100
            cell.menuView.layer.borderColor = AppColor.purple70?.cgColor
        }
        
        return cell
    }
    
    /// 헤더 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        if collectionView.tag == 1 {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NoseCollectionReusableView.identifier,
            for: indexPath
        ) as! NoseCollectionReusableView
        
        let section = NoseManager.shared.scentSections[indexPath.section]
        
        // 상태(isExpanded) 전달 - 헤더 configure 함수 호출
        header.configure(with: section.header, section: indexPath.section, delegate: self, isExpanded: section.isExpand)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 { // noseCollectionView
            logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.noseCellTapped, fileName: #file, cellID: NoseCollectionReusableView.identifier)
            // 데이터 직접 수정
            NoseManager.shared.scentSections[indexPath.section].scents[indexPath.row].isSelected.toggle()
        }
        
        let selectedCount = NoseManager.shared.scentSections.flatMap { $0.scents }.filter { $0.isSelected }.count
        middleView.nextButton.isEnabled(isEnabled: selectedCount >= 3)
        
        collectionView.reloadItems(at: [indexPath])
        Task {
            self.topView.selectedCollectionView.reloadData()
            self.topView.updateSelectedCollectionViewHeight()
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalTo(self.middleView.snp.bottom).offset(30)
            }
            
            self.view.layoutIfNeeded() // 레이아웃 강제 업데이트
        }
    }
}

extension EditNoseViewController: NoseHeaderViewDelegate {
    // 토글 애니메이션 추가
    func toggleSection(_ section: Int) {
        NoseManager.shared.scentSections[section].isExpand.toggle()
        
        // 애니메이션 적용
        let indexSet = IndexSet(integer: section)
        middleView.noseCollectionView.performBatchUpdates({
            middleView.noseCollectionView.reloadSections(indexSet)
        }, completion: { [self] _ in
            // 레이아웃 강제 업데이트
            self.middleView.noseCollectionView.layoutIfNeeded()
            
            // 컬렉션 뷰의 높이 계산
            let collectionViewContentHeight = self.middleView.noseCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            // middleView의 높이 업데이트
            self.middleView.snp.remakeConstraints { make in
                make.top.equalTo(self.topView.snp.bottom).offset(DynamicPadding.dynamicValue(24.0))
                make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
                make.height.greaterThanOrEqualTo(collectionViewContentHeight + DynamicPadding.dynamicValue(140.0))
                make.bottom.equalToSuperview()
            }
            
            // contentView의 제약 조건도 업데이트
            self.contentView.snp.updateConstraints { make in
                make.bottom.equalTo(self.middleView.snp.bottom).offset(30)
            }
            
            // 전체 레이아웃 강제 업데이트
            self.view.layoutIfNeeded()
        })
    }
}

extension EditNoseViewController: UICollectionViewDelegateFlowLayout {
    /// 섹션 간 여백
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // 좌우 여백 10
    }
    
    /// 셀 간 가로 간격(셀 옆 간격)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// 셀 간 세로 간격(줄 간격)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 각 셀의 크기
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let totalSpacing = (itemsPerRow - 1) * 10 + 20 // 셀 간 간격 + 좌우 여백(10씩)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            // selectedCollectionView의 헤더 크기를 0으로 설정
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 52) // 기본 헤더 크기
    }
}
