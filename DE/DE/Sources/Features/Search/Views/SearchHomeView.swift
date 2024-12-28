//
//  SearchHomeView.swift
//  Drink-EG
//
//  Created by 이현주 on 10/30/24.
//

import UIKit
import CoreModule
import SnapKit
import Then

class SearchHomeView: UIView {
    
    public lazy var backBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = Constants.AppColor.gray80
        $0.backgroundColor = .clear
    }
    
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

    init(titleText: String, placeholder: String) {
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
        [backBtn, title, searchBar, searchResultTableView].forEach { self.addSubview($0) }
    }

    private func setConstraints() {
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(19)
            make.leading.equalTo(safeAreaLayoutGuide).offset(31)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(29)
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

