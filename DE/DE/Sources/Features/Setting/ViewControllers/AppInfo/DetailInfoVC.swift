// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class DetailInfoVC: UIViewController {
    
    // MARK: - Properties
    private let navigationBarManager = NavigationBarManager()
    
    private let contentLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 16)
        $0.textColor = AppColor.gray70
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private var itemTitle: String?
    private var itemContent: String?
    
    // MARK: - Initializer
    init(title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        self.itemTitle = title
        self.itemContent = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar(itemTitleString: itemTitle ?? "앱 정보")
        setupUI()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar(itemTitleString: String) {
        // itemTitle을 네비게이션 바 제목으로 설정
        navigationBarManager.setTitle(to: navigationItem, title: itemTitleString, textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configure Data
    private func configureData() {
        contentLabel.text = itemContent
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
