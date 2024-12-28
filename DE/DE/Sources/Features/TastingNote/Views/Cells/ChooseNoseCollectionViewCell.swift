// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class ChooseNoseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleCell = UICollectionView.CellRegistration<UICollectionViewListCell, ChooseNose> { cell, indexPath, itemIdentifier in
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = itemIdentifier.title
        contentConfiguration.textProperties.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        cell.contentConfiguration = contentConfiguration
        
        let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: .black)
        
        cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
    }
    
    let flowerItem = [
        ChooseNose(title: "", subItems: [], item: Channel(name: "장미")),
        ChooseNose(title: "", subItems: [], item: Channel(name: "말린 꽃"))
    ]
    
    // let flowerSection = ChooseNose(title: "꽃 계열", subItems: flowerItem)
    
}
