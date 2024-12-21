//
//  SearchHomeView.swift
//  Drink-EG
//
//  Created by 이현주 on 10/30/24.
//

import UIKit
import SnapKit
import Then

class SearchHomeView: UIView {
    
    public lazy var backBtn: UIButton = {
        let b = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        b.setImage(image, for: .normal)
        b.tintColor = Constants.AppColor.gray80
        b.backgroundColor = .clear
        return b
    }()
    
    public lazy var title: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        let text = "검색하고 싶은\n와인을 입력해주세요"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25 // 줄 간격 설정

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Constants.AppColor.DGblack ?? .black
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        l.attributedText = attributedText
        
        return l
    }()

    public var searchBar: SearchBar = SearchBar()
        
    public lazy var searchResultTableView: UITableView = {
        let t = UITableView()
        t.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        t.separatorStyle = .none
        return t
    }()
    
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
        [backBtn, title, searchBar, searchResultTableView].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
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
