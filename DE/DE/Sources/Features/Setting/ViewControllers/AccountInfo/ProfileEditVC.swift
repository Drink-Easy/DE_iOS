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
    private let imagePickerManager = ImagePickerManager()
    
    private let networkService = MemberService()
    
    private let profileView = ProfileView()
    
    private let ValidationManager = NicknameValidateManager()
    
    lazy var profileImgFileName: String = ""
    lazy var profileImg: UIImage? = nil
    
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
        setupImagePicker()
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
    
    // MARK: - 이미지 피커 설정
    private func setupImagePicker() {
        // 이미지 선택 후 동작 설정
        imagePickerManager.onImagePicked = { [weak self] image, fileName in
            guard let self = self else { return }
            print("setupImagePicker")
            self.profileView.profileImageView.image = image
            self.profileImgFileName = fileName
            self.profileImg = image
        }
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
        let profileDTO = networkService.makeMemberInfoUpdateRequestDTO(username: profileView.nicknameTextField.text! , city: profileView.myLocationTextField.text ?? "예시 위치 정보")
        networkService.patchUserInfo(body: profileDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.navigationController?.popViewController(animated: true)
                print("프로필 업데이트 완료")
                Task {
                    await self.updateCallCount()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateCallCount() async {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        Task {
            // patch count + 1
            do {
                try await APICallCounterManager.shared.incrementPatch(for: userId, controllerName: .member)
            } catch {
                print(error)
            }
            
        }
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
        imagePickerManager.presentImagePicker(from: self)
    }
    
    //MARK: - 위치 정보 불러오기 로직
    @objc func getMyLocation() {
                LocationManager.shared.requestLocationPermission { [weak self] address in
                    DispatchQueue.main.async {
                        self?.profileView.myLocationTextField.textField.text = address ?? ""
                    }
                }
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
