// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class AverageTastingNoteView: UIView {
    
    private let title = TitleWithBarView(title: "Tasting Note", subTitle: "테이스팅 노트")

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
        [title].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
