// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class TastedDateViewController: UIViewController {

    let tastedDateView = TastedDateView()
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tastedDateView)
        tastedDateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        tastedDateView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        tastedDateView.calender.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        tastedDateView.calender.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        guard let selectedDate = selectedDate else {
            print("선택된 날짜가 없습니다.")
            return
        }
        
        if let date = Calendar.current.date(from: selectedDate) {
            // 날짜를 `String`으로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            // UserDefaults에 저장
            UserDefaults.standard.set(dateString, forKey: "tasteDate")
            print("날짜 저장됨: \(dateString)")
        }
        
        let nextVC = ChooseWineColorViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
