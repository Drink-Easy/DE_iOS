// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        
    }
}
