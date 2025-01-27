// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class SearchHomeView: UIView {
    
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

    public var searchBar = SearchBar()

    public lazy var searchResultTableView = UITableView().then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = Constants.AppColor.grayBG
    }

    public init(titleText: String, placeholder: String) {
        super.init(frame: .zero)
        backgroundColor = Constants.AppColor.grayBG

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
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            make.leading.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(25.0))
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(DynamicPadding.dynamicValue(16.0))
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(24.0))
            make.height.equalTo(DynamicPadding.dynamicValue(48.0))
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(DynamicPadding.dynamicValue(18.0))
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(18.0))
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

