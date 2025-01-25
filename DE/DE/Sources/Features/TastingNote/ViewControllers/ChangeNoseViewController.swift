// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

// 향 수정 뷰컨

public class ChangeNoseViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var sections: [NoseSectionModel] = NoseSectionModel.sections() // 섹션 데이터
    var selectedItems: [String: [NoseModel]] = [:]
    var allNoseModels: [NoseModel]  {
        selectedItems.values.flatMap { $0 }
    }
    
    let chooseNoseView = ChangeNoseView()
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    var dto: TastingNoteResponsesDTO
    
    
    init(dto: TastingNoteResponsesDTO) {
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.gray20
        print(dto)
        setupUI()
        setupCollectionView() // CollectionView 설정
        setupActions()
        setupNavigationBar()
        
        loadInitialData()
        
        chooseNoseView.updateUI(wineName: dto.wineName)
    }
    
    private func setupUI() {
        view.addSubview(chooseNoseView)
        chooseNoseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        // 레이아웃 설정
        let noseCollectionView = chooseNoseView.collectionView // ChooseNoseView의 컬렉션 뷰 사용
        noseCollectionView.delegate = self
        noseCollectionView.dataSource = self
        
        // 셀 및 헤더 등록
        noseCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        noseCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        let selectedCollectionView = chooseNoseView.selectedCollectionView
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        
        selectedCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        // selectedCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func setupActions() {
        chooseNoseView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(selectedItems)
            UserDefaults.standard.set(data, forKey: "nose")
            print("\(selectedItems)")
        } catch {
            print("\(error)")
        }
        
        callNotePatchNose()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 초기 데이터 로트
    private func loadInitialData() {
        selectedItems = noseMapListToSelectItems(dto.noseMapList)
        
        // ✅ UI 업데이트를 메인 스레드에서 수행
        DispatchQueue.main.async {
            self.chooseNoseView.collectionView.reloadData()
            self.chooseNoseView.selectedCollectionView.reloadData()
            self.chooseNoseView.updateSelectedCollectionViewHeight(itemCount: self.allNoseModels.count)
        }
    }
    
    
    // MARK: - noseMapList 변환 함수
    private func noseMapListToSelectItems(_ noseMapList: [[String: String]]) -> [String: [NoseModel]] {
        var result: [String: [NoseModel]] = [:]
        
        for noseMap in noseMapList {
            for (key, value) in noseMap {
                let noseModel = NoseModel(type: value)
                
                // 섹션 제목을 찾아서 해당 섹션에 추가
                if let section = sections.first(where: { $0.items.contains(where: { $0.type == value }) }) {
                    let sectionTitle = section.sectionTitle
                    if result[sectionTitle] == nil {
                        result[sectionTitle] = []
                    }
                    result[sectionTitle]?.append(noseModel)
                }
            }
        }
        return result
    }
    
    private func updateSectionSelection() {
        for sectionIndex in sections.indices {
            let sectionTitle = sections[sectionIndex].sectionTitle
            if let selectedItemsInSection = selectedItems[sectionTitle] {
                sections[sectionIndex].selectedItems = selectedItemsInSection
            }
        }
    }
    
    func callNotePatchNose() {
        // 기존 noseMapList에서 noseId 목록 추출
        let initialNoseIds = dto.noseMapList.compactMap { Int($0.keys.first!) }
        
        // 현재 선택된 noseType 목록
        let currentNoseTypes = selectedItems.flatMap { $0.value.map { $0.type } }
        
        // 추가된 항목: 현재 선택된 항목 중 기존에 없는 항목의 noseId 추출
        let addNoseList = currentNoseTypes.filter { type in
            !dto.noseMapList.contains(where: { $0.values.first == type })
        }
        
        // 제거된 항목: 기존 noseId 중 현재 선택되지 않은 항목
        let removeNoseList = initialNoseIds.filter { id in
            !dto.noseMapList.contains(where: { $0.keys.first == "\(id)" && currentNoseTypes.contains($0.values.first!) })
        }
        
        // 서버에 PATCH 요청
        sendPatchRequest(addNoseList: addNoseList, removeNoseList: removeNoseList)
    }
    
    private func sendPatchRequest(addNoseList: [String], removeNoseList: [Int]) {
        let updateRequest = TastingNoteUpdateRequestDTO(
            color: nil,
            tastingDate: nil,
            sugarContent: nil,
            acidity: nil,
            tannin: nil,
            body: nil,
            alcohol: nil,
            addNoseList: addNoseList,
            removeNoseList: removeNoseList,
            rating: nil,
            review: nil
        )
        
        let patchDTO = TastingNotePatchRequestDTO(noteId: dto.noteId, body: updateRequest)
        
//        noteService.patchNote(data: patchDTO, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    print("PATCH 요청 성공: \(response)")
//                }
//            case .failure(let error):
//                print("PATCH 요청 실패: \(error)")
//            }
//        })
    }
}

extension ChangeNoseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션 수
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return sections.count
        } else if collectionView.tag == 1 {
            return 1 //selectedItems.values.count
        }
        return 0
    }
    
    // 각 섹션의 아이템 수 - 접혀있으면 0으로 고정
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return sections[section].isExpanded ? sections[section].items.count : 0
        } else if collectionView.tag == 1 {
            return allNoseModels.count
        }
        return 0
    }
    
    // 셀 설정
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as? NoseCollectionViewCell else {
            fatalError("셀 등록 실패")
        }
        
        if collectionView.tag == 0 {
            // tag == 0: 전체 항목
            let item = sections[indexPath.section].items[indexPath.item]
            cell.menuLabel.text = item.type
            
            let sectionTitle = sections[indexPath.section].sectionTitle
            if let selectedItems = selectedItems[sectionTitle], selectedItems.contains(where: { $0.type == item.type }) {
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple100?.cgColor
            } else {
                cell.menuView.backgroundColor = AppColor.gray40
                cell.menuLabel.textColor = AppColor.gray100
                cell.menuView.layer.borderColor = UIColor.clear.cgColor
            }
        } else if collectionView.tag == 1 {
            // tag == 1: 선택된 항목
//            let keys = Array(selectedItems.keys)
//            let key = keys[indexPath.section]
            let item = allNoseModels[indexPath.item]
                cell.menuLabel.text = item.type
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple100?.cgColor
            }
        return cell
    }
    
    // 헤더 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        if collectionView.tag == 1 {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as! NoseCollectionReusableView
        
        let section = sections[indexPath.section]
        // 상태(isExpanded) 전달 - 헤더 configure 함수 호출
        header.configure(with: section.sectionTitle, section: indexPath.section, delegate: self, isExpanded: section.isExpanded)
        return header
    }
}

extension ChangeNoseViewController: NoseHeaderViewDelegate {
    // 토글 애니메이션에 대한 것
    func toggleSection(_ section: Int) {
        sections[section].isExpanded.toggle()
        
        // 애니메이션 적용
        let indexSet = IndexSet(integer: section)
        chooseNoseView.collectionView.performBatchUpdates({
            chooseNoseView.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
}

extension ChangeNoseViewController: UICollectionViewDelegateFlowLayout {
    // 섹션 간 여백
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 좌우 여백 10
    }
    
    // 셀 간 가로 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 셀 간 간격
    }
    
    // 셀 간 세로 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 줄 간 간격
    }
    
    // 각 셀의 크기
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3 // 한 줄에 표시될 셀의 개수
        let totalSpacing = (itemsPerRow - 1) * 10 + 20 // 셀 간 간격 + 좌우 여백(10씩)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: 50) // 셀 높이는 고정
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            // selectedCollectionView의 헤더 크기를 0으로 설정
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 50) // 기본 헤더 크기
    }
}

extension ChangeNoseViewController {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            // 첫 번째 컬렉션 뷰: 전체 항목
            let section = indexPath.section
            let sectionTitle = sections[section].sectionTitle
            let item = sections[section].items[indexPath.item]
            
            if selectedItems[sectionTitle] == nil {
                selectedItems[sectionTitle] = []
            }
            
            if let index = selectedItems[sectionTitle]?.firstIndex(where: { $0.type == item.type }) {
                // 이미 선택된 항목 -> 선택 해제
                selectedItems[sectionTitle]?.remove(at: index)
                if selectedItems[sectionTitle]?.isEmpty == true {
                    selectedItems.removeValue(forKey: sectionTitle)
                }
            } else {
                // 새로 선택된 항목
                selectedItems[sectionTitle]?.append(item)
            }
            
            // tag == 0 및 tag == 1 컬렉션 뷰 모두 업데이트
            collectionView.reloadItems(at: [indexPath])
            chooseNoseView.selectedCollectionView.reloadData()
            chooseNoseView.updateSelectedCollectionViewHeight(itemCount: self.allNoseModels.count)
            chooseNoseView.updateNoseCollectionViewHeight()
        }
    }
}

//protocol NoseHeaderViewDelegate: AnyObject {
//    func toggleSection(_ section: Int) // 섹션 상태 토글을 위한 델리게이트 메서드
//}
