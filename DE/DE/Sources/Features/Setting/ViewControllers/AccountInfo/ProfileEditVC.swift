// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import PhotosUI

import SnapKit
import Then

import CoreModule
import CoreLocation
import Network

class ProfileEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    private let navigationBarManager = NavigationBarManager()
    private let networkService = MemberService()
    
    private let profileView = ProfileView()
    
    private let ValidationManager = NicknameValidateManager()
    
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
        view.backgroundColor = AppColor.bgGray
        
        setupUI()
        setupConstraints()
        setupNavigationBar()
        setupActions()
        configureTapGestureForDismissingPicker()
    }
        
    // MARK: - 네비게이션 바 설정
    func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "프로필 설정", textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
        navigationBarManager.addRightButton(
            to: navigationItem,
            title: "완료",
            target: self,
            action: #selector(editCompleteTapped),
            tintColor: AppColor.gray70 ?? .gray,
            font: UIFont.ptdSemiBoldFont(ofSize: 16)
        )
    }
    
    // MARK: UI Component 설정
    func setupUI() {
        view.addSubview(profileView)
    }
    
    func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight * 0.9)
        }
    }

    func setupActions() {
        profileView.profileImageEditButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)
        profileView.nicknameTextField.textField.addTarget(self, action: #selector(validateNickname), for: .editingChanged)
        profileView.checkDuplicateButton.addTarget(self, action: #selector(checkNicknameValidity), for: .touchUpInside)
        profileView.myLocationTextField.textField.addTarget(self, action: #selector(checkFormValidity), for: .allEditingEvents)
        profileView.locationImageIconButton.addTarget(self, action: #selector(getMyLocation), for: .touchUpInside)
    }
    
    //MARK: Functions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editCompleteTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureTapGestureForDismissingPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker() {
        view.endEditing(true)
    }
    
    // 프로필 이미지 선택
    @objc func selectProfileImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택 가능
        configuration.selectionLimit = 1 // 하나의 이미지만 선택

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - 위치 정보 불러오기 로직
    @objc func getMyLocation() {
//        LocationManager.shared.requestLocationPermission { [weak self] address in
//            DispatchQueue.main.async {
//                self?.profileView.myLocationTextField.textField.text = address ?? ""
//            }
//        }
    }
    
    //MARK: - 닉네임 중복 검사
    @objc func checkNicknameValidity(){
        guard let nickname = profileView.nicknameTextField.text, !nickname.isEmpty else {
            print("닉네임이 없습니다")
            return
        }
        
        ValidationManager.checkNicknameDuplicate(nickname: nickname, view: profileView.nicknameTextField)
    }
    
    //MARK: - 폼 유효성 검사
    @objc func validateNickname(){
        ValidationManager.isNicknameCanUse = false
        ValidationManager.validateNickname(profileView.nicknameTextField)
        checkFormValidity()
    }
    
    @objc func checkFormValidity() {
        let isNicknameValid = !(profileView.nicknameTextField.textField.text?.isEmpty ?? true) && !ValidationManager.isNicknameCanUse
        let isLocationValid = !(profileView.myLocationTextField.textField.text?.isEmpty ?? true)
        let isImageSelected = profileView.profileImageView.image != nil
        let isFormValid = isNicknameValid && isLocationValid && isImageSelected
    }
}

extension ProfileEditVC: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let result = results.first else { return }

        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                guard let self = self else { return }
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.profileView.profileImageView.image = image
                        //TODO: 이미지 데이터 어디에 저장?
                    }
                } else {
                    print("이미지를 불러오지 못했습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                }
            }
        } else {
            print("선택한 항목에서 이미지를 로드할 수 없습니다.")
        }
    }
}
