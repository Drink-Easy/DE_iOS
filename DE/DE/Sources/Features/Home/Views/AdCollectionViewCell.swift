// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import SnapKit

class AdCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AdCollectionViewCell"
    
    private let image = UIImageView().then {
        $0.image = UIImage(named: "ad4")
        $0.contentMode = .scaleAspectFill
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
    
    func configure(image: String) {
        if let image = UIImage(named: image) {
            self.image.image = image
        }
    }
}
