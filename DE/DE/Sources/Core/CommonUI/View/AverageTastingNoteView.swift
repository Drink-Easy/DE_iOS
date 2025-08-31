// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class AverageTastingNoteView: UIView {
    private let title = TitleWithoutBarView(title: "Tasting Note", subTitle: "테이스팅 노트")
    public let writeNewTastingNoteBtn = TextIconButton(title: "작성하러 가기")
    
    private let tastingNoteContentView = UIView()
    private let noTastingNote = UILabel().then {
        $0.isHidden = true
    }
    
    private let nose = UILabel()
    private let palate = UILabel()
    public lazy var noseContents = UILabel()
    public lazy var palateContents = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews(title, writeNewTastingNoteBtn, tastingNoteContentView, noTastingNote)
        tastingNoteContentView.addSubviews(nose, palate, noseContents, palateContents)
    
        AppTextStyle.KR.body2.apply(to: nose, text: "Nose", color: AppColor.gray50)
        AppTextStyle.KR.body2.apply(to: palate, text: "Palate", color: AppColor.gray50)
        AppTextStyle.KR.body2.apply(
            to: noTastingNote,
            text: "작성된 테이스팅 노트가 없습니다.",
            color: AppColor.gray70
        )
        
        [noseContents, palateContents].forEach {
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    private func setupLayout() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        
        writeNewTastingNoteBtn.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        tastingNoteContentView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        noTastingNote.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        nose.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        noseContents.snp.makeConstraints {
            $0.top.equalTo(nose.snp.top)
            $0.leading.equalTo(nose.snp.trailing).offset(33)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        palate.snp.makeConstraints {
            $0.top.equalTo(noseContents.snp.bottom).offset(8)
            $0.leading.equalTo(nose.snp.leading)
        }
    
        palateContents.snp.makeConstraints {
            $0.top.equalTo(palate.snp.top)
            $0.leading.equalTo(palate.snp.trailing).offset(27)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    public func configure(_ model: WineAverageTastingNoteModel, _ vintage: Int?) {
        let hasContent = (vintage != nil) && !model.wineNoseText.isEmpty
        
        tastingNoteContentView.isHidden = !hasContent
        noTastingNote.isHidden = hasContent
        
        if hasContent {
            AppTextStyle.KR.body3.apply(to: noseContents, text: model.wineNoseText, color: AppColor.gray100)
            AppTextStyle.KR.body3.apply(to: palateContents, text: "\(model.sugarContentDescription()), \(model.acidityDescription()), \(model.tanninDescription()), \(model.bodyDescription()), \(model.alcoholDescription())", color: AppColor.gray100)
            
            AppTextStyle.KR.body2.apply(to: noTastingNote, text: "", color: AppColor.gray70)
        } else {
            AppTextStyle.KR.body3.apply(to: noseContents, text: "", color: AppColor.gray100)
            AppTextStyle.KR.body3.apply(to: palateContents, text: "", color: AppColor.gray100)
            
            let message = (vintage == nil) ? "빈티지를 선택해 주세요." : "작성된 테이스팅 노트가 없습니다."
            AppTextStyle.KR.body2.apply(to: noTastingNote, text: message, color: AppColor.gray70)
        }
        
        self.layoutIfNeeded()
    }
}
