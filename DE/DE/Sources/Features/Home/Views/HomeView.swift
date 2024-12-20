//
//  HomeView.swift
//  Drink-EG
//
//  Created by 이현주 on 12/17/24.
//

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
