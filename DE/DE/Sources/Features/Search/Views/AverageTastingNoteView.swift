// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then

class AverageTastingNoteView: UIView {
    
    private let title = TitleWithBarView(title: "Tasting Note", subTitle: "테이스팅 노트")
    
    private func createTitle(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = UIFont.ptdMediumFont(ofSize: 18)
        }
    }
    
    private func createContents(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = UIFont.ptdRegularFont(ofSize: 14)
        }
    }
    
    private lazy var nose = createTitle(text: "Nose")
    private lazy var palate = createTitle(text: "Palate")
    public lazy var noseContents = createContents(text: "신선한, 시트러스, 미묘한, 배")
    public lazy var palateContents = createContents(text: "섬세한, 농축된, 균형잡힌, 생동감, 아몬드")

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.AppColor.grayBG
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, nose, palate, noseContents, palateContents].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        nose.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(26)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
        
        palate.snp.makeConstraints {
            $0.top.equalTo(nose.snp.bottom).offset(16)
            $0.leading.equalTo(nose.snp.leading)
        }
        
        noseContents.snp.makeConstraints {
            $0.centerY.equalTo(nose)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(89)
        }
        
        palateContents.snp.makeConstraints {
            $0.centerY.equalTo(palate)
            $0.leading.equalTo(noseContents.snp.leading)
            $0.bottom.equalToSuperview()
        }
    }
}
