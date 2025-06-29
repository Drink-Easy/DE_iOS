// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import DesignSystem
import CoreModule
import SnapKit
import Then

public final class VintageTableViewController: UIViewController {
    
    // MARK: - Properties
    private var sections: [Section<VintageItem>] = []
    
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
        setupLayout()
        setupTableView()
        setupDummyData()
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
    
    private func setupDummyData() {
        // 1980년대부터 2020년대까지의 섹션 생성
        let decades = [
            (title: "2020년대", startYear: 2020),
            (title: "2010년대", startYear: 2010),
            (title: "2000년대", startYear: 2000),
            (title: "1990년대", startYear: 1990),
            (title: "1980년대", startYear: 1980),
            (title: "1970년대", startYear: 1970)
        ]
        
        sections = decades.map { decade in
            let endYear = decade.startYear == 2020 ? 2024 : decade.startYear + 9
            
            let items = (decade.startYear...endYear)
                .reversed()
                .map { year in
                    VintageItem(
                        year: year,
                        score: Double.random(in: 3.0...5.0)
                    )
                }
            
            return Section(
                title: decade.title,
                isExpanded: false,
                items: items
            )
        }
        
        tableView.reloadData()
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
