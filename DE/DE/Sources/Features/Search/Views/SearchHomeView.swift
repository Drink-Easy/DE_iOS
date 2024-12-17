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
        b.setImage(UIImage(named: "icon_arrow_back"), for: .normal)
        b.tintColor = UIColor(hex: "#767676")
        b.backgroundColor = .clear
        return b
    }()
    
    public lazy var title: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.text = "검색하고 싶은\n와인을 입력해주세요"
        l.textColor = UIColor(hex: "#121212")
        l.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        return l
    }()

    public var searchBar: SearchBar = SearchBar()
        
//    public lazy var searchResultTableView: UITableView = {
//        let t = UITableView()
//        t.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
//        t.separatorStyle = .none
//        return t
//    }()
    
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
        [backBtn, title, searchBar].forEach{ self.addSubview($0) }
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
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
    }
}
