// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChooseWineColorViewController: UIViewController {
    var selectedColor : String?
    let navigationBarManager = NavigationBarManager()
    let colorView = SelectColorView()
    
    let tnManger = NewTastingNoteManager.shared
    let colorDatas = WineColorManager()
    let wineData = TNWineDataManager.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorView.header.setTitleLabel(wineData.wineName)
        colorView.infoView.countryContents.text = wineData.country + "," + wineData.region
        colorView.infoView.kindContents.text = wineData.sort
        colorView.infoView.typeContents.text = wineData.variety
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
        
        colorView.colorCollectionView.delegate = self
        colorView.colorCollectionView.dataSource = self
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.bgGray
    }
    
    func setupActions() {
        colorView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray90!
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
        colorView.nextButton.isEnabled = true
        
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedColor = nil
        colorView.nextButton.isEnabled = false
        
        collectionView.reloadData()
    }
    
}
