// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class MyOwnedWineViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    var wineResults: [String] = ["루이 로드레 빈티지 로제 브뤼", "루이 로드레 컬렉션 244", "루이 로드레 크리스탈 2015"]
    
    private lazy var myWienTableView = UITableView().then {
        $0.register(MyWineTableViewCell.self, forCellReuseIdentifier: MyWineTableViewCell.identifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = Constants.AppColor.grayBG
        $0.dataSource = self
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        addComponents()
        setConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "보유와인",
            textColor: AppColor.black ?? .black
        )
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "plus",
            target: self,
            action: #selector(addNewWine),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addNewWine() {
        let vc = AddNewWineViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addComponents() {
        [myWienTableView].forEach { view.addSubview($0) }
    }

    private func setConstraints() {
        myWienTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(651)
        }
    }
}

extension MyOwnedWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyWineTableViewCell.identifier, for: indexPath) as? MyWineTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineResults[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    //스와이프 시작 시 셀 배경색 변경
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = AppColor.purple10
        }
    }

    // 스와이프 종료 시 셀 배경색 복원
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = AppColor.bgGray
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 커스텀 삭제 액션
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            
            // 삭제 로직
            self.wineResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true) // 완료 상태 전달
        }
        
        // 버튼 색상 설정
        deleteAction.backgroundColor = AppColor.purple100

        // 아이콘 설정
        deleteAction.image = UIImage(systemName: "trash")

        // Swipe Action 구성
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

