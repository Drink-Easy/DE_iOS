// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class MyOwnedWineView: UIView {

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = .clear
        return s
    }()
    
    private let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
    let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.rowHeight = 92
        $0.showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom)
        }
    }
}
