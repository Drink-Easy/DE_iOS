// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import DesignSystem
import CoreModule
import SnapKit
import Then

public final class VintageTableViewController: UIViewController {
    
    // MARK: - Properties
    private var sections: [Section<VintageItem>] = []
    private let navigationBarManager = NavigationBarManager()
    
    public var onYearSelected: ((Int) -> Void)?
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = AppColor.background
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.sectionHeaderTopPadding = 0
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupLayout()
        setupTableView()
        setupSectionData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "빈티지 선택하기", textColor: AppColor.black)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀과 헤더뷰 등록
        tableView.register(VintageTableViewCell.self,
                           forCellReuseIdentifier: VintageTableViewCell.identifier)
        tableView.register(ExpandableHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ExpandableHeaderView.identifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
    
    private func setupSectionData() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let fixedStartYear = 1970
        var currentDecadeStartYear = (currentYear / 10) * 10 // 예: 2025년 -> 2020년
        
        var dynamicSections: [Section<VintageItem>] = []
        
        while currentDecadeStartYear >= fixedStartYear {
            let startYear = currentDecadeStartYear
            let endYear = (startYear == (currentYear / 10) * 10) ? (currentYear - 1) : (startYear + 9)
            guard startYear <= endYear else {
                currentDecadeStartYear -= 10
                continue
            }
            
            let items = (startYear...endYear)
                .reversed()
                .map { year in
                    VintageItem(year: year, score: 0.0)
                }
            
            let section = Section(
                title: "\(currentDecadeStartYear)년대",
                isExpanded: false,
                items: items
            )
            dynamicSections.append(section)
            
            currentDecadeStartYear -= 10
        }
        
        self.sections = dynamicSections
        tableView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension VintageTableViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isExpanded ? sections[section].items.count : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VintageTableViewCell.identifier,
            for: indexPath
        ) as? VintageTableViewCell else {
            return UITableViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(year: item.year, score: item.score)
        
        return cell
    }
    
}

extension VintageTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ExpandableHeaderView.identifier
        ) as? ExpandableHeaderView else {
            return nil
        }
        
        headerView.configure(with: sections[section], at: section)
        headerView.delegate = self
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedYear = sections[indexPath.section].items[indexPath.row].year
        onYearSelected?(selectedYear)
        
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ExpandableHeaderViewDelegate
extension VintageTableViewController: ExpandableHeaderViewDelegate {
    
    public func expandableHeaderView(_ headerView: ExpandableHeaderView, didTapSection section: Int) {
        // 섹션의 확장 상태 토글
        sections[section].isExpanded.toggle()
        
        // 애니메이션과 함께 섹션 리로드
        tableView.performBatchUpdates({
            tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }, completion: nil)
    }
}
