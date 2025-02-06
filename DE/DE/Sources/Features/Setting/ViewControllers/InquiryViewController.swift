// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SafariServices
import MessageUI

import SnapKit
import Then

import CoreModule

class InquiryViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    struct InquiryMenuItem {
        let title: String
        let iconImage: String
    }
    
    private let InquiryMenuItems: [InquiryMenuItem] = [
        InquiryMenuItem(title: "메일로 문의하기", iconImage: "mailIcon"),
        InquiryMenuItem(title: "카카오로 문의하기", iconImage: "messageIcon")
    ]
    
    private let inquiryLabel = UILabel().then {
        $0.text = "운영 시간 안내"
        $0.textColor = AppColor.black
        $0.font = UIFont.ptdMediumFont(ofSize: 18)
    }
    private let descriptionLabel = UILabel().then {
        let text = "접수시간 - 24시간 접수 가능\n답변시간 - 평일 10:00 - 18:00 (주말, 공휴일 제외)"
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.7 // 줄 간격 적용
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        $0.attributedText = attributedString
        $0.textColor = AppColor.gray70
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.numberOfLines = 0
    }
    private var tableView = UITableView()
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.bgGray
        setupUI()
        setupTableView()
        setupNavigationBar()
        setNavBarAppearance(navigationController: self.navigationController)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "문의하기",
            textColor: AppColor.black ?? .black
        )
    }
    
    func setupUI() {
        [inquiryLabel, descriptionLabel].forEach {
            view.addSubview($0)
        }
        inquiryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(12))
            make.leading.equalTo(DynamicPadding.dynamicValue(24))
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(inquiryLabel.snp.bottom).offset(DynamicPadding.dynamicValue(8))
            make.leading.equalTo(inquiryLabel.snp.leading)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor = AppColor.bgGray
        tableView.register(InquiryMenuViewCell.self, forCellReuseIdentifier: InquiryMenuViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(DynamicPadding.dynamicValue(16))
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension InquiryViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InquiryMenuItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InquiryMenuViewCell.identifier, for: indexPath) as? InquiryMenuViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(iconImage:InquiryMenuItems[indexPath.row].iconImage, name: InquiryMenuItems[indexPath.row].title)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension InquiryViewController: UITableViewDelegate, MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = InquiryMenuItems[indexPath.row].title
        
        switch selectedItem {
        case "메일로 문의하기":
            openMail()
        case "카카오로 문의하기":
            openKakao()
        default:
            break
        }
    }
    
    @objc func openMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as?String ?? "Unknown"
            let osVersion = UIDevice.current.systemVersion
            let deviceModel = getDeviceModel()
                
            let bodyString = """
                            - 아래 정보를 작성해 주세요
                            1. 문의 내용 : 
                            
                            
                            2. 드링키지 메일 계정 : 
                            (마이페이지 - 계정 정보에서 확인 가능)
                            
                            문의 관련 스크린샷을 첨부하시면 더욱 빠른 처리가 가능합니다
                            
                            ================================
                            
                            드링키지는 문의에 포함된 개인정보와 연락처 정보를 수집, 이용할 수 있습니다. 다만, 이러한 정보는 답변을 위한 목적으로만 처리됩니다.
                            
                            자세한 내용은 드링키지 앱의 마이페이지 - 앱 정보에 있는 개인정보 처리방침을 참고하시기 바랍니다.
                            
                            ================================
                            
                            App Version : \(appVersion)
                            Device OS : \(osVersion)
                            Device Model : \(deviceModel)
                            
                            ================================
                            """
            composeVC.setToRecipients(["drinkeasyy@gmail.com"])
            composeVC.setSubject("문의 및 건의하기")
            composeVC.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeVC, animated: true)
        } else {
            // 만약, 디바이스에 email 기능이 비활성화 일 때, 사용자에게 알림
            let alertController = UIAlertController(title: "메일 계정 활성화 필요",
                                                    message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.compactMap { $0.value as? Int8 }
            .filter { $0 != 0 }
            .map { String(UnicodeScalar(UInt8($0))) }
            .joined()
        
        return mapToDevice(identifier: identifier) ?? identifier
    }
    
    /// 모델 ID를 실제 기기명으로 변환
    func mapToDevice(identifier: String) -> String? {
        let deviceList: [String: String] = [
            // ✅ iPhone X 시리즈 (2017)
            "iPhone10,3": "iPhone X",   // 글로벌
            "iPhone10,6": "iPhone X",   // GSM
            
            // ✅ iPhone XR & XS 시리즈 (2018)
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max (중국 모델)",
            "iPhone11,6": "iPhone XS Max (글로벌)",
            "iPhone11,8": "iPhone XR",
            
            // ✅ iPhone 11 시리즈 (2019)
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            
            // ✅ iPhone SE 시리즈
            "iPhone8,4": "iPhone SE (1세대)",  // 2016
            "iPhone12,8": "iPhone SE (2세대)", // 2020
            "iPhone14,6": "iPhone SE (3세대)", // 2022
            
            // ✅ iPhone 12 시리즈 (2020)
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            
            // ✅ iPhone 13 시리즈 (2021)
            "iPhone14,2": "iPhone 13 Pro",
                "iPhone14,3": "iPhone 13 Pro Max",
                "iPhone14,4": "iPhone 13 mini",
                "iPhone14,5": "iPhone 13",
                
                // ✅ iPhone 14 시리즈 (2022)
                "iPhone15,2": "iPhone 14 Pro",
                "iPhone15,3": "iPhone 14 Pro Max",
                "iPhone15,4": "iPhone 14",
                "iPhone15,5": "iPhone 14 Plus",
                
                // ✅ iPhone 15 시리즈 (2023)
                "iPhone16,1": "iPhone 15 Pro",
                "iPhone16,2": "iPhone 15 Pro Max",
                "iPhone16,3": "iPhone 15",
                "iPhone16,4": "iPhone 15 Plus",
                
                // 🔥 iPhone 16 시리즈 (예상, 2024)
                "iPhone17,1": "iPhone 16 Pro",
                "iPhone17,2": "iPhone 16 Pro Max",
                "iPhone17,3": "iPhone 16",
                "iPhone17,4": "iPhone 16 Plus"
                
                // 💡 필요하면 최신 모델 추가 가능!
            ]
        
        return deviceList[identifier]
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        let alertTitle: String
        let alertMessage: String
        
        switch result {
        case .sent:
            alertTitle = "성공"
            alertMessage = "메일을 성공적으로 보냈습니다."
        case .cancelled:
            alertTitle = "취소됨"
            alertMessage = "메일 작성을 취소했습니다."
        case .saved:
            alertTitle = "임시 저장"
            alertMessage = "메일이 임시 저장되었습니다."
        case .failed:
            alertTitle = "실패"
            alertMessage = "메일 전송에 실패했습니다."
        @unknown default:
            alertTitle = "알 수 없음"
            alertMessage = "예기치 않은 결과가 발생했습니다."
        }
        
        // 알림 표시
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        controller.dismiss(animated: true) { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
    
    @objc func openKakao() {
        if let url = URL(string: "http://pf.kakao.com/_esxcKn/chat") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
