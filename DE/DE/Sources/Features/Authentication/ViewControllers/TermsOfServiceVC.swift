import UIKit
import SnapKit
import CoreModule

class TermsOfServiceVC: UIViewController, UIDocumentInteractionControllerDelegate {
    
    // MARK: - Properties
    let navigationBarManager = NavigationBarManager()
    
    var agreements: [Bool] = [false, false, false, false]
    private var isAllAgreed: Bool = false
    
    private var agreeItems: [TermsAgreeView] = []
    
    // MARK: - UI Components
    private let subHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자의 더 특별한 경험을 위해\n약관 동의가 필요합니다."
        label.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let allTitleLabel = UILabel().then {
        $0.text = "전체 약관 동의"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.gray30
        return view
    }()
    
    private let allToggleButton = UIButton(type: .system).then {
        $0.tintColor = AppColor.gray30
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(allAgreeButtonTapped), for: .touchUpInside)
    }
    
    private let startButton = CustomButton(
        title: "시작하기",
        titleColor: .white,
        backgroundColor: AppColor.gray30!
    ).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "서비스 약관 동의", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        
        [subHeaderLabel, allTitleLabel, allToggleButton, dividerView, startButton].forEach {
            view.addSubview($0)
        }
        
        for index in 0..<3 {
            let title = ["개인정보 수집 및 이용 동의 (필수)", "위치정보 이용약관 (필수)", "서비스 이용약관 (필수)"][index]
            //TODO: pdf 추가 & 이름 설정
            let pdfName = ["privacy_policy", "location", "service"][index]
            let agreeView = createAgreeView(title: title, pdfName: pdfName, index: index)
            
            agreeItems.append(agreeView)
            view.addSubview(agreeView)
        }
    }
    
    private func setupConstraints() {
        subHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().inset(30)
        }
        allToggleButton.snp.makeConstraints { make in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(30)
            make.width.height.equalTo(24)
        }
        
        allTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allToggleButton)
            make.leading.equalTo(allToggleButton.snp.trailing).offset(10)
        }
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(allTitleLabel.snp.bottom).offset(20)
        }
        
        for (index, view) in agreeItems.enumerated() {
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                
                if index == 0 {
                    make.top.equalTo(dividerView.snp.bottom).offset(20) // 첫 번째 뷰의 제약 조건
                } else {
                    make.top.equalTo(agreeItems[index - 1].snp.bottom).offset(10) // 이전 뷰의 아래쪽에 위치
                }
                
                make.height.equalTo(30)
            }
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    
    // MARK: - Factory Method
    private func createAgreeView(title: String, pdfName: String, index: Int) -> TermsAgreeView {
        return TermsAgreeView().then { agreeView in
            agreeView.configure(
                title: title,
                moreLink: pdfName,
                isChecked: agreements[index],
                parentViewController: self
            )
            
            agreeView.onStateChange = { [weak self] isChecked in
                guard let self = self else { return }
                self.agreements[index] = isChecked
                self.updateStartButtonState()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func allAgreeButtonTapped() {
        isAllAgreed.toggle()
        agreements = Array(repeating: isAllAgreed, count: agreements.count)
        allToggleButton.tintColor = isAllAgreed ? AppColor.purple100 : AppColor.gray30
        agreeItems.forEach { $0.setChecked(isChecked: isAllAgreed) }
        updateStartButtonState()
    }
    
    private func updateStartButtonState() {
        let allRequiredAgreed = agreements.prefix(3).allSatisfy { $0 }
        startButton.isEnabled = allRequiredAgreed
        startButton.backgroundColor = allRequiredAgreed ? AppColor.purple100! : AppColor.gray30!
    }
    
    @objc private func startButtonTapped() {
        //TODO: 취향찾기 뷰컨 연결
            print("모든 필수 약관에 동의하셨습니다. 서비스를 시작합니다.")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
