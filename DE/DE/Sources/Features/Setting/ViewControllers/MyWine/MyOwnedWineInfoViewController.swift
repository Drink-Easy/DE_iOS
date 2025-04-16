// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem
import Network

public class MyOwnedWineInfoViewController: UIViewController, ChildViewControllerDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.myWineDetailVC
    
    let navigationBarManager = NavigationBarManager()
    let networkService = MyWineService()
    private let errorHandler = NetworkErrorHandler()
    
    //MARK: UI Elements
    private lazy var header = MyNoteTopView()
    private lazy var wineDetailView = SimpleListView()
    public lazy var deleteButton = CustomButton(title: "다 마셨어요", isEnabled: true)
    
    var registerWine: MyWineViewModel?
    var needUpdate: Bool = false
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setWineData()
        wineDetailView.setEditButton(showEditButton: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
        fetchMyWineAPI()
    }
    
    private func setWineData() {
        guard let currentWine = self.registerWine else { return }
        header.setWineName(currentWine.wineName)
        header.infoView.image.sd_setImage(with: URL(string: currentWine.wineImageUrl), placeholderImage: UIImage(named: "placeholder"))
        header.infoView.typeContents.text = "\(currentWine.wineCountry), \(currentWine.wineRegion)"
        header.infoView.countryContents.text = currentWine.wineVariety
        header.infoView.kindContents.text = currentWine.wineSort
        
        self.setWineDetailInfo(currentWine)
        wineDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.background
        [header, wineDetailView, deleteButton].forEach{
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.greaterThanOrEqualTo(180)
        }
        
        wineDetailView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(36))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(40))
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    private func setWineDetailInfo(_ registerWine: MyWineViewModel) {
        let priceString = formatPrice(registerWine.purchasePrice)
        wineDetailView.titleLabel.text = "구매 정보"
        if registerWine.period >= 0 {
            wineDetailView.items = [("구매 가격", "\(priceString)원"),
                                    ("구매일 D+\(registerWine.period+1)", "\(registerWine.purchaseDate)")]
        } else {
            wineDetailView.items = [("구매 가격", "\(priceString)원"),
                                    ("구매일 D\(registerWine.period)", "\(registerWine.purchaseDate)")]
        }
    }
    
    public func didUpdateData(_ newData: Bool) {
        self.needUpdate = newData
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.editBtnTapped, fileName: #file)
        guard let currentWine = self.registerWine else { return }
        
        let nextVC = ChangeMyOwnedWineViewController()
        nextVC.delegate = self
        nextVC.registerWine = currentWine
        
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func deleteButtonTapped() {
        guard let currentWine = self.registerWine else { return }
        
        let alert = UIAlertController(
            title: "이 와인을 삭제하시겠습니까?",
            message: "\(currentWine.wineName)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.deleteBtnTapped, fileName: #file)
            self.callDeleteAPI()
            
            DispatchQueue.main.async {
                self.view.hideBlockingView()
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func callDeleteAPI() {
        self.view.showBlockingView()
        Task {
            do {
                _ = try await networkService.deleteMyWine(myWineId: registerWine!.myWineId)
                self.view.hideBlockingView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func fetchMyWineAPI() {
        self.view.showBlockingView()
        Task {
            do {
                let data = try await networkService.fetchMyWine(myWineId: registerWine!.myWineId)
                DispatchQueue.main.async { [self] in
                    self.registerWine = MyWineViewModel(myWineId: data.myWineId, wineId: data.wineId, wineName: data.wineName, wineSort: data.wineSort, wineCountry: data.wineCountry, wineRegion: data.wineRegion, wineVariety: data.wineVariety, wineImageUrl: data.wineImageUrl, purchaseDate: data.purchaseDate, purchasePrice: data.purchasePrice, period: data.period)
                    self.setWineData()
//                    self.needUpdate = false
                    self.view.hideBlockingView()
                }
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
}
