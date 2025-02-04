// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster
import Network

class ManiaCountryViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    let networkService = MemberService()
    
    let cellData = ["프랑스", "이탈리아", "미국", "스페인", "아르헨티나", "독일", "호주", "포르투갈", "캐나다", "뉴질랜드", "슬로베니아", "헝가리", "오스트리아", "대한민국", "그리스", "칠레"]
    
    private var selectedItems: [String] = []
    private let maxSelectionCount = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = surveyKindView
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var surveyKindView = SurveyKindView(titleText: "선호하는 와인 생산국을\n골라주세요", currentPage: 4, entirePage: 4, buttonTitle: "내 취향 저장하기").then {
        $0.surveyKindCollectionView.delegate = self
        $0.surveyKindCollectionView.dataSource = self
        
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        UserSurveyManager.shared.setArea(selectedItems)
        callPatchAPI()
    }
    
    private func callPatchAPI() {
        let userMng = UserSurveyManager.shared
        let bodyData = networkService.makeMemberInfoRequestDTO(name: userMng.name,
                                                               isNewbie: userMng.isNewbie,
                                                               monthPrice: userMng.monthPrice,
                                                               wineSort: userMng.wineSort,
                                                               wineArea: userMng.wineArea,
                                                               wineVariety: userMng.wineVariety,
                                                               region: userMng.region)
        
        networkService.postUserInfo(body: bodyData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                networkService.postImg(image: userMng.imageData) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success (let response):
                        
                        Task {
                            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                                print("⚠️ userId가 UserDefaults에 없습니다.")
                                return
                            }
                            
                            do {
                                // 캐시데이터에 기본 유저 정보 저장
                                try await PersonalDataManager.shared.createPersonalData(for: userId, userName: userMng.name, userCity: userMng.region)
                                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .member)
                                try await APICallCounterManager.shared.incrementPatch(for: userId, controllerName: .member)
                            } catch {
                                print(error)
                            }
                            
                            // UI 전환
                            await MainActor.run {
                                let homeTabBarController = MainTabBarController()
                                SelectLoginTypeVC.keychain.set(false, forKey: "isFirst")
                                
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first {
                                    window.rootViewController = homeTabBarController
                                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                                }
                            }
                        }
                    case .failure(let error) :
                        print(error)
                    }
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
    
}

extension ManiaCountryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyKindCollectionViewCell.identifier, for: indexPath) as! SurveyKindCollectionViewCell
        
        let title = cellData[indexPath.row]
        cell.configure(contents: title)
        
        cell.isSelected = selectedItems.contains(title)
        cell.updateAppearance(isSelected: cell.isSelected)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = cellData[indexPath.row]
        
        if selectedItems.contains(selectedItem) { //이미 selected된 cell
            selectedItems.removeAll { $0 == selectedItem }
        } else {
//            if selectedItems.count >= maxSelectionCount { // 이미 2개 선택
//                Toaster.shared.makeToast("선택할 수 있는 갯수를 초과했습니다.", .short)
//                return
//            }
            // 새 아이템 선택
            selectedItems.append(selectedItem)
        }
        
        // UI 업데이트
        collectionView.reloadData()
        surveyKindView.nextButton.isEnabled = selectedItems.count >= 1
        surveyKindView.nextButton.isEnabled(isEnabled: selectedItems.count >= 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = cellData[indexPath.row]
        let font = UIFont.ptdMediumFont(ofSize: 16)
        let size = title.size(withAttributes: [.font: font])
        
        let padding: CGFloat = DynamicPadding.dynamicValue(44.0)
        let cellWidth = size.width + padding
        
        return CGSize(width: cellWidth, height: DynamicPadding.dynamicValue(49.0))
    }
}
