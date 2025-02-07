// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import SnapKit
import CoreModule
import SDWebImage

class AdCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AdCollectionViewCell"
    
    private let image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "adPlaceholder")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        constraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(image)
    }
    
    private func constraints() {
        image.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(model: HomeBannerModel) {
        if let url = URL(string: model.imageUrl) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "adPlaceholder"))
        } else {
            image.image = UIImage(named: "adPlaceholder")
        }
    }
}
