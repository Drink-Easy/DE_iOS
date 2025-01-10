// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class MyOwnedWineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let myOwnedWineTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(MyWineTableViewCell.self, forCellReuseIdentifier: MyWineTableViewCell.identifier)
    }
    
    func setupUI() {
        addSubview(myOwnedWineTableView)
        myOwnedWineTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}
