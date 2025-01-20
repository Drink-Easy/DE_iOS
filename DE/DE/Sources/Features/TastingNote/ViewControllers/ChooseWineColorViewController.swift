// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

// 2번 선택 뷰컨 테이스팅 노트 : 색상 선택

public class ChooseWineColorViewController: UIViewController {
    var selectedColor : String?
    let navigationBarManager = NavigationBarManager()
    lazy var colorView = SelectColorView().then {
        $0.colorCollectionView.delegate = self
        $0.colorCollectionView.dataSource = self
    }
    
    let tnManger = NewTastingNoteManager.shared
    let colorDatas = WineColorManager()
    let wineData = TNWineDataManager.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorView.header.setTitleLabel(wineData.wineName)
        colorView.infoView.countryContents.text = wineData.country + ", " + wineData.region
        colorView.infoView.kindContents.text = wineData.sort
        colorView.infoView.typeContents.text = wineData.variety
//        colorView.header.setTitleLabel("디자인 테스트")
//        colorView.infoView.countryContents.text = "디자인" + ", " + "테스트"
//        colorView.infoView.kindContents.text = "테스트"
//        colorView.infoView.typeContents.text = "테스트"
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
        setupActions()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.bgGray
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
        colorView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
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
        guard let selectedColor = self.selectedColor else {
            print("선택된 색상이 없습니다.")
            return
        }
        
        tnManger.saveColor(selectedColor)
        let nextVC = ChooseNoseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ChooseWineColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let selectedColorHexCode = colorDatas.colors[indexPath.row].colorHexCode
        selectedColor = selectedColorHexCode
        colorView.nextButton.isEnabled(isEnabled: true)
        
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedColor = nil
        colorView.nextButton.isEnabled(isEnabled: false)
        
        collectionView.reloadData()
    }
    
}
