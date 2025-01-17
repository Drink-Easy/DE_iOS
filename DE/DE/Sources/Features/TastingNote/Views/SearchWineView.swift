// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

class SearchWineView: UIView {

    public lazy var title = UILabel().then {
        $0.numberOfLines = 0
        let text = "검색하고 싶은\n와인을 입력해주세요"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25 // 줄 간격 설정

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Constants.AppColor.DGblack ?? .black
        ]
        $0.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    public var searchBar = WineSearchBar()

    public lazy var searchResultTableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
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
        [title, searchBar, searchResultTableView].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(25)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-18)
        }
    }
}
