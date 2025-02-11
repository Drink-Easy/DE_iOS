// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class DetailInfoVC: UIViewController {
    
    // MARK: - Properties
    private let navigationBarManager = NavigationBarManager()
    
    private let textView = UITextView().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 16)
        $0.textColor = AppColor.gray100
        $0.backgroundColor = .clear
        $0.isEditable = false // 읽기 전용
        $0.isScrollEnabled = true // 자체 스크롤 활성화
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // 좌우 여백 추가
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
        setNavBarAppearance(navigationController: self.navigationController)
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
        navigationBarManager.setTitle(to: navigationItem, title: itemTitleString, textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Configure Data
    private func configureData() {
        textView.text = itemContent
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
