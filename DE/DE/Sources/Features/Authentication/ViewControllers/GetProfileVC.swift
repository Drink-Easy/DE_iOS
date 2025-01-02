// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class GetProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let navigationBarManager = NavigationBarManager()
    
    private let headerLabel = UILabel().then {
        $0.text = "프로필을 만들어 보세요!"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profilePlaceholder")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    
    let profileImageEditButton = UIButton().then {
        $0.backgroundColor = AppColor.purple100
        $0.layer.cornerRadius = 15
    }
    
    let profileImageIconView = UIImageView().then {
        let iconImage = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        $0.image = iconImage
        $0.tintColor = .white
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nicknameTextField = CustomTextFieldView(
        descriptionLabelText: "닉네임",
        textFieldPlaceholder: "닉네임을 입력해 주세요"
    )
    
    private lazy var myLocationTextField = CustomTextFieldView(
        descriptionLabelText: "내 동네",
        textFieldPlaceholder: ""
    )
    
    let locationImageIconView = UIImageView().then {
        let iconImage = UIImage(systemName: "plus.magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        $0.image = iconImage
        $0.tintColor = AppColor.gray70
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    let startButton = CustomButton(
        title: "시작하기",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        setupUI()
        setupConstraints()
        setupNavigationBar()
        
        configureTapGestureForProfileImage()
        configureTapGestureForDismissingPicker()
    }
    
    // MARK: - 네비게이션 바 설정
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
    }
    
    // MARK: UI Component 설정
    func setupUI() {
        [headerLabel, profileImageView, profileImageEditButton, profileImageIconView, nicknameTextField, myLocationTextField, locationImageIconView, startButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().inset(30)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        profileImageEditButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.centerY.equalTo(profileImageView.snp.bottom).offset(-20)
        }
        profileImageIconView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerX.centerY.equalTo(profileImageEditButton)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        myLocationTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(72)
        }
        locationImageIconView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(myLocationTextField.snp.trailing).offset(16)
            make.bottom.equalTo(myLocationTextField.snp.bottom).offset(-12)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    //    func findViewController() -> UIViewController? {
    //        if let nextResponder = self.next as? UIViewController {
    //            return nextResponder
    //        } else if let nextResponder = self.next as? UIView {
    //            return nextResponder.findViewController()
    //        } else {
    //            return nil
    //        }
    //    }
    
    //MARK: Functions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startButtonTapped() {
        //TODO: 뷰컨 연결
    }
    
    func configureTapGestureForProfileImage() {
        profileImageEditButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)
    }
    
    func configureTapGestureForDismissingPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker() {
        view.endEditing(true)
    }
    
    // 프로필 이미지 선택
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            //TODO: 이미지 데이터 어디에 저장?
            
        } else {
            print("이미지 선택 실패")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // 닉네임 또는 생년월일 변경 시 호출
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFormValidity()
    }
    
    // 폼 유효성 검사
    func checkFormValidity() {
        let isFormValid = !(nicknameTextField.textField.text?.isEmpty ?? true) //TODO: 동네 isEmpty 추가
        
        startButton.isEnabled = isFormValid
        startButton.backgroundColor = isFormValid ? AppColor.purple100 : AppColor.gray30
    }
}
