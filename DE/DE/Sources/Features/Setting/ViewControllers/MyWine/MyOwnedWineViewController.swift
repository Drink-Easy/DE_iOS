// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class MyOwnedWineViewController: UIViewController {
    
    let myOwnedWineView = MyOwnedWineView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        myOwnedWineView.myOwnedWineTableView.dataSource = self
        myOwnedWineView.myOwnedWineTableView.delegate = self
    }
}

extension MyOwnedWineViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 예시 데이터 개수
        return MyOwnedWineModel.sections().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyWineTableViewCell.identifier, for: indexPath) as! MyWineTableViewCell
        // ✅ 셀에 데이터 설정
        let wine = MyOwnedWineModel.sections()[indexPath.row]
        cell.configure(with: wine)
        
        return cell
    }
}
