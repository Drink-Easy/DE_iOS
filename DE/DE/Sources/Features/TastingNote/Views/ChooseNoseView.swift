//
//  ChooseNoseView.swift
//  Drink-EG
//
//  Created by 이수현 on 12/17/24.
//

import UIKit

class ChooseNoseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        w.textColor = .black
        return w
    }()
    
    private let noseLabel: UILabel = {
        let n = UILabel()
        n.text = "Nose"
        n.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        n.textColor = .black
        return n
    }()
    
    private let noseLabelKorean: UILabel = {
        let n = UILabel()
        n.text = "향"
        n.font = UIFont.ptdRegularFont(ofSize: 14)
        n.textColor = UIColor(hex: "#767676")
        return n
    }()
    
    private let vector1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    private let noseDescription: UILabel = {
        let n = UILabel()
        n.text = "와인을 시음하기 전, 향을 맡아보세요! 와인 잔을 천천히 돌려 잔의 표면에 와인을 묻히면 잔 속에 향이 풍부하게 느껴져요."
        n.font = UIFont.ptdRegularFont(ofSize: 14)
        n.textColor = UIColor(hex: "#767676")
        return n
    }()

}
