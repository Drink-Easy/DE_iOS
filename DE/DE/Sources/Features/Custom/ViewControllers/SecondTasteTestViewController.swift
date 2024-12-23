//
//  SecondTasteTestViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/2/24.
//

import UIKit

class SecondTasteTestViewController: UIViewController {
    
    let firstButton = UIButton(type: .custom)
    let secondButton = UIButton(type: .custom)
    let thirdButton = UIButton(type: .custom)
    let fourthButton = UIButton(type: .custom)
    
    let nextButton = UIButton(type: .system)
    
    private let Label: UILabel = {
        let l = UILabel()
        l.text = "와인에 한달 평균..."
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
        
        configureFirstButton()
        configureSecondButton()
        configureThirdButton()
        configureFourthButton()
        configureNextButton()
        
        view.addSubview(Label)
        Label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
//            make.width.equalTo(338)
//            make.height.equalTo(44)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton, fourthButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
                
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(Label.snp.bottom).offset(49)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.greaterThanOrEqualTo(368)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.equalTo(60)
        }
    }
    
    private func configureFirstButton() {
        firstButton.setTitle("5만원 이하로 써요", for: .normal)
        firstButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        firstButton.titleLabel?.numberOfLines = 0
        firstButton.setTitleColor(.black, for: .normal)
        firstButton.contentHorizontalAlignment = .left
        firstButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        firstButton.backgroundColor = UIColor(hex: "#FFCDC5")
        firstButton.layer.cornerRadius = 16
        firstButton.layer.borderWidth = 3
        firstButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        firstButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureSecondButton() {
        secondButton.setTitle("5-10만원 정도 써요", for: .normal)
        secondButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        secondButton.titleLabel?.numberOfLines = 0
        secondButton.setTitleColor(.black, for: .normal)
        secondButton.contentHorizontalAlignment = .left
        secondButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        secondButton.backgroundColor = UIColor(hex: "#FFCDC5")
        secondButton.layer.cornerRadius = 16
        secondButton.layer.borderWidth = 3
        secondButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        secondButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureThirdButton() {
        thirdButton.setTitle("10-30만원 정도 써요", for: .normal)
        thirdButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        thirdButton.titleLabel?.numberOfLines = 0
        thirdButton.setTitleColor(.black, for: .normal)
        thirdButton.contentHorizontalAlignment = .left
        thirdButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        thirdButton.backgroundColor = UIColor(hex: "#FFCDC5")
        thirdButton.layer.cornerRadius = 16
        thirdButton.layer.borderWidth = 3
        thirdButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        thirdButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureFourthButton() {
        fourthButton.setTitle("30만원 이상 써요", for: .normal)
        fourthButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        fourthButton.titleLabel?.numberOfLines = 0
        fourthButton.setTitleColor(.black, for: .normal)
        fourthButton.contentHorizontalAlignment = .left
        fourthButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        fourthButton.backgroundColor = UIColor(hex: "#FFCDC5")
        fourthButton.layer.cornerRadius = 16
        fourthButton.layer.borderWidth = 3
        fourthButton.layer.borderColor = UIColor(hex: "#FF9F8E")?.cgColor
        
        fourthButton.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        
        for Btn in [firstButton, secondButton, thirdButton, fourthButton] {
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
        if firstButton.isSelected || secondButton.isSelected || thirdButton.isSelected || fourthButton.isSelected {
            nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(hex: "FA735B")
            
            if firstButton.isSelected {
                SelectionManager.shared.setPrice(answer: 50000)
            } else if secondButton.isSelected {
                SelectionManager.shared.setPrice(answer: 100000)
            } else if thirdButton.isSelected {
                SelectionManager.shared.setPrice(answer: 300000)
            } else if fourthButton.isSelected {
                SelectionManager.shared.setPrice(answer: 10000000)
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
        let thirdTasteTestViewController = ThirdKindTasteTestViewController()
        navigationController?.pushViewController(thirdTasteTestViewController, animated: true)
    }
}
