// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class MyOwnedWineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyWineTableViewCell.identifier, for: indexPath)
        //cell.wineImage = UIImage(named: "Loxton")
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    private lazy var myWineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyWineTableViewCell.self, forCellReuseIdentifier: MyWineTableViewCell.identifier)
        
        return tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }()
    
    
    

}
