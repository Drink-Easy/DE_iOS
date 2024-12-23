//
//  FirstTasteTestViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/2/24.
//

import UIKit

class FirstTasteTestViewController: UIViewController {
    
    let newbeeButton = UIButton(type: .custom)
    let maniacButton = UIButton(type: .custom)
    
    let nextButton = UIButton(type: .system)
    
    private let iamLabel: UILabel = {
        let l = UILabel()
        l.text = "저는..."
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(rawValue: 700))
        
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        
        configureNewbeeButton()
        configureManiacButton()
        configureNextButton()
        
        view.addSubview(iamLabel)
        iamLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
//            make.width.equalTo(338)
//            make.height.equalTo(44)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [newbeeButton, maniacButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
                
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(iamLabel.snp.bottom).offset(49)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.greaterThanOrEqualTo(328)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.equalTo(60)
        }
    }
    
    private func configureNewbeeButton() {
        let fulltext = "와인 뉴비\n\n와인은 아직 잘 몰라요!\n배워보고 싶은 뉴비에요."
        newbeeButton.setTitle(fulltext, for: .normal)
        let attributedStr = NSMutableAttributedString(string: fulltext)
        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight(rawValue: 600)), range: (fulltext as NSString).range(of: "와인 뉴비"))
        newbeeButton.setAttributedTitle(attributedStr, for: .normal)
        newbeeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        newbeeButton.titleLabel?.numberOfLines = 0
        newbeeButton.setTitleColor(.black, for: .normal)
        newbeeButton.contentHorizontalAlignment = .left
        newbeeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        newbeeButton.backgroundColor = UIColor(hex: "#FFCDC5")
        newbeeButton.layer.cornerRadius = 16
        newbeeButton.layer.borderWidth = 3
        newbeeButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        newbeeButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureManiacButton() {
        let fulltext = "와인 매니아\n\n이미 와인을 즐기고 있어요!\n더 재밌게 즐기고픈 매니아에요."
        maniacButton.setTitle(fulltext, for: .normal)
        let attributedStr = NSMutableAttributedString(string: fulltext)
        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight(rawValue: 600)), range: (fulltext as NSString).range(of: "와인 매니아"))
        maniacButton.setAttributedTitle(attributedStr, for: .normal)
        maniacButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        maniacButton.titleLabel?.numberOfLines = 0
        maniacButton.setTitleColor(.black, for: .normal)
        maniacButton.contentHorizontalAlignment = .left
        maniacButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        maniacButton.backgroundColor = UIColor(hex: "#FFCDC5")
        maniacButton.layer.cornerRadius = 16
        maniacButton.layer.borderWidth = 3
        maniacButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        maniacButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        
        for Btn in [newbeeButton, maniacButton] {
            if Btn == sender {
                // 만약 현재 버튼이 이 함수를 호출한 버튼이라면
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(hex: "#FF9F8E")
                Btn.layer.cornerRadius = 16
                Btn.layer.borderWidth = 0
            } else {
                // 이 함수를 호출한 버튼이 아니라면
                Btn.isSelected = false
                Btn.backgroundColor = UIColor(hex: "#FFCDC5")
                Btn.layer.cornerRadius = 16
                Btn.layer.borderWidth = 3
                Btn.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
            }
        }
        // 선택된 버튼에 따른 다음 버튼 활성화
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        // 하나의 선택 버튼이라도 선택되면 다음 버튼 활성화
        if newbeeButton.isSelected || maniacButton.isSelected {
            nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(hex: "FA735B")
            
            // 버튼 선택 결과 전달
            if newbeeButton.isSelected {
                SelectionManager.shared.setNewbie(answer: true)
            } else if maniacButton.isSelected {
                SelectionManager.shared.setNewbie(answer: false)
            }
        } else {
            nextButton.removeTarget(nil, action: nil, for: .allEvents)
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
        }
    }
    
    private func configureNextButton() {
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        
        nextButton.setImage(UIImage(named: "icon_next"), for: .normal)
        nextButton.imageView?.contentMode = .center
        nextButton.tintColor = .white
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 0)
        
        nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
        nextButton.layer.cornerRadius = 16
        nextButton.layer.borderWidth = 0
    }
    
    @objc private func nextButtonTapped() {
        let secondTastTestViewController = SecondTasteTestViewController()
        navigationController?.pushViewController(secondTastTestViewController, animated: true)
    }
}
