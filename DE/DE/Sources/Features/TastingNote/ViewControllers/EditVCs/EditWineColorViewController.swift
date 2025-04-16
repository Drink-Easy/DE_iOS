// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import DesignSystem
import SDWebImage

// 색상 변경

public class EditWineColorViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.editWineColorVC
    
    let navigationBarManager = NavigationBarManager()
    private let errorHandler = NetworkErrorHandler()
    
    lazy var colorView = EditColorView().then {
        $0.colorCollectionView.delegate = self
        $0.colorCollectionView.dataSource = self
    }
    
    let networkService = TastingNoteService()
    let colorDatas = WineColorManager()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    var selectedColor : String?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        colorView.setWineName(wineData.wineName)
        colorView.infoView.image.sd_setImage(with: URL(string: wineData.imageUrl))
        colorView.infoView.countryContents.text = wineData.country + ", " + wineData.region
        colorView.infoView.kindContents.text = wineData.sort
        colorView.infoView.typeContents.text = wineData.variety.replacingOccurrences(of: " ,", with: ",")
        selectedColor = tnManager.color
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
        setupActions()
        setupNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.background
        colorView.propertyHeader.setName(eng: "Color", kor: "색상")
        colorView.colorCollectionView.register(WineColorCollectionViewCell.self, forCellWithReuseIdentifier: "WineColorCollectionViewCell")
    }
    
    func setConstraints() {
        view.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        colorView.nextButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    @objc func saveButtonTapped() {
        logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.saveBtnTapped,
                       fileName: #file)
        
        guard let selectedColor = self.selectedColor else {
            return
        }
        
        tnManager.saveColor(selectedColor)
        callUpdateAPI()
    }
    
    private func callUpdateAPI() {
        let updateData = networkService.makeUpdateNoteBodyDTO(color: selectedColor)
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        self.view.showBlockingView()
        Task {
            do {
                let _ = try await networkService.patchNote(data: tnData)
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
}

extension EditWineColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorDatas.colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineColorCollectionViewCell", for: indexPath) as? WineColorCollectionViewCell else {
            fatalError("Could not dequeue cell with identifier WineColorCollectionViewCell")
        }
        
        let colorData = colorDatas.colors[indexPath.row]
        let colorHex = UIColor(hex: colorData.colorHexCode)
        let isLight = colorData.isLight
        let isSelected = (selectedColor == colorData.colorHexCode) // 선택된 색상과 비교
        
        cell.configure(colorhex: colorHex, isSelected: isSelected, isLight: isLight)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        let totalSpacing = spacing * 3
        let width = (collectionView.frame.width - totalSpacing) / 4
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.colorCellTapped, fileName: #file, cellID: "WineColorCollectionViewCell")
        let selectedColorHexCode = colorDatas.colors[indexPath.row].colorHexCode
        selectedColor = selectedColorHexCode
        
        collectionView.reloadData()
    }
}
