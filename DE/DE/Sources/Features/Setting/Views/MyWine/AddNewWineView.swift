// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import DesignSystem

public class AddNewWineView: UIView {
    
    public lazy var title = UILabel().then {
        $0.numberOfLines = 0
        let text = "검색하고 싶은\n와인을 입력해주세요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25 // 줄 간격 설정
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(.semiBold, size: 24),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: AppColor.black
        ]
        $0.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    public var searchBar = SearchBar()

    public lazy var searchResultTableView = UITableView().then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = AppColor.background
    }

    public init(titleText: String, placeholder: String) {
        super.init(frame: .zero)
        backgroundColor = AppColor.background

        title.text = titleText
        searchBar.placeholderText = placeholder

        addComponents()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addComponents() {
        [title, searchBar, searchResultTableView].forEach { self.addSubview($0) }
    }

    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
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
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

