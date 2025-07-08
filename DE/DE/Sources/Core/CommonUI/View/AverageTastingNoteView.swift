// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class AverageTastingNoteView: UIView {
    
    private lazy var noTastinNote = UILabel().then {
        $0.text = "작성된 테이스팅 노트가 없습니다."
        $0.textColor = AppColor.gray70
        $0.font = UIFont.pretendard(.regular, size: 14)
        $0.isHidden = true
    }
    
    private let title = TitleWithBarView(title: "Tasting Note", subTitle: "테이스팅 노트")
    public let writeNewTastingNoteBtn = TextIconButton(title: "작성하러 가기")
    
    private func createTitle(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.pretendard(.medium, size: 18)
        }
    }
    
    private func createContents(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.pretendard(.regular, size: 14)
            $0.numberOfLines = 0
        }
    }
    
    private lazy var nose = createTitle(text: "Nose")
    private lazy var palate = createTitle(text: "Palate")
    public lazy var noseContents = createContents(text: "")
    public lazy var palateContents = createContents(text: "")

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        self.addSubviews(title, writeNewTastingNoteBtn, nose, palate, noseContents, palateContents, noTastinNote)
    
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(23)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        writeNewTastingNoteBtn.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(24)
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
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-26)
        }
        
        palateContents.snp.makeConstraints {
            $0.top.equalTo(palate.snp.top)
            $0.leading.equalTo(noseContents.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-26)
            //$0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        noTastinNote.snp.makeConstraints { 
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    public func configure(_ model: WineAverageTastingNoteModel) {
        if model.avgAcidity == 0.0 {
            nose.isHidden = true
            palate.isHidden = true
            noseContents.isHidden = true
            palateContents.isHidden = true
            [nose, palate, noseContents, palateContents].forEach { view in
                view.removeFromSuperview()
            }
            noTastinNote.isHidden = false
        } else {
            [title, writeNewTastingNoteBtn, nose, palate, noseContents, palateContents].forEach{ self.addSubview($0) }
            noseContents.text = model.wineNoseText
            palateContents.text = "\(model.sugarContentDescription()), \(model.acidityDescription()), \(model.tanninDescription()),\n\(model.bodyDescription()), \(model.alcoholDescription())"
        }
        self.layoutIfNeeded()
    }
}
