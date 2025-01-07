// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class NewWineInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.textColor = .black
        w.textAlignment = .left
        w.numberOfLines = 0
        w.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        return w
    }()
    
    private let wineImage: UIImageView = {
        let w = UIImageView()
        w.contentMode = .scaleToFill
        w.image = UIImage(named: "wine1")
        w.layer.cornerRadius = 14
        return w
    }()
    
    let descriptionView = DescriptionUIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .white
    }
    
    let buyInfo = UILabel().then {
        $0.text = "구매 정보"
        $0.textColor = .black
        $0.font = .ptdSemiBoldFont(ofSize: 18)
    }
    
    let changeLabel = UILabel().then {
        $0.text = "수정하기"
        $0.textColor = AppColor.gray70
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.isUserInteractionEnabled = true
    }
    
    

}
