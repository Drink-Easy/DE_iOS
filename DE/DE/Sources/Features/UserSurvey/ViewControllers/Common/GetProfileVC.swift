// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import PhotosUI

import SnapKit
import Then

import CoreModule
import CoreLocation
import Network

public class GetProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    private let navigationBarManager = NavigationBarManager()
    private let imagePickerManager = ImagePickerManager()
    
    private let networkService = MemberService()
    
    private let profileView = ProfileView()
    
    private let ValidationManager = NicknameValidateManager()
    
    var userName : String?
    var userRegion : String?
    lazy var profileImgFileName: String = ""
    lazy var profileImg: UIImage? = nil
    
    private var userNickName : String?
    
    private let headerLabel = UILabel().then {
        $0.text = "프로필을 만들어 보세요!"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let nextButton = CustomButton(
        title: "다음",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
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
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    // MARK: - 이미지 피커 설정
    private func setupImagePicker() {
        // 이미지 선택 후 동작 설정
        imagePickerManager.onImagePicked = { [weak self] image, fileName in
            guard let self = self else { return }
            self.profileView.profileImageView.image = image
            self.profileImgFileName = fileName
            self.profileImg = image
        }
    }
    
    // MARK: UI Component 설정
    func setupUI() {
        [headerLabel, profileView, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(16.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight * 0.5)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(40.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
        }
    }
    
    func setupActions() {
        profileView.profileImageEditButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)
        profileView.nicknameTextField.textField.addTarget(self, action: #selector(validateNickname), for: .editingChanged)
        profileView.checkDuplicateButton.addTarget(self, action: #selector(checkNicknameValidity), for: .touchUpInside)
        profileView.myLocationTextField.textField.addTarget(self, action: #selector(checkFormValidity), for: .allEditingEvents)
        profileView.locationImageIconButton.addTarget(self, action: #selector(getMyLocation), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Functions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        // 정보 저장
        guard let name = self.userName,
              let addr = self.userRegion,
              let profileImg = self.profileImg else { return }
        UserSurveyManager.shared.setPersonalInfo(name: name, addr: addr, profileImg: profileImg)
        
        let vc = IsNewbieViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureTapGestureForDismissingPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissImagePicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissImagePicker() {
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
                self?.checkFormValidity()
            }
        }
    }
    
    //MARK: - 닉네임 중복 검사
    @objc func checkNicknameValidity(){
        guard let nickname = profileView.nicknameTextField.text, !nickname.isEmpty else {
            print("닉네임이 없습니다")
            return
        }
        
        ValidationManager.checkNicknameDuplicate(nickname: nickname, view: profileView.nicknameTextField) {
                self.checkFormValidity() // 네트워크 응답 후 호출
            }
    }
    
    //MARK: - 닉네임 유효성 검사
    @objc func validateNickname(){
        ValidationManager.isNicknameCanUse = false
        ValidationManager.isLengthValid = false
        ValidationManager.validateNickname(profileView.nicknameTextField)
        checkFormValidity()
    }
    
    //MARK: - 폼 유효성 검사
    @objc func checkFormValidity() {
        let isNicknameValid =  ValidationManager.isNicknameCanUse && ValidationManager.isLengthValid
        let isLocationValid = !(profileView.myLocationTextField.textField.text?.isEmpty ?? true)
        let isImageSelected = profileView.profileImageView.image != nil
        let isFormValid = isNicknameValid && isLocationValid && isImageSelected
        
        print("isNicknameValid == \(isNicknameValid)")
        print("isLocationValid == \(isLocationValid)")
        print("isImageSelected == \(isImageSelected)")
        print("isFormValid == \(isFormValid)")
        self.userName = profileView.nicknameTextField.textField.text
        self.userRegion = profileView.myLocationTextField.textField.text
        self.profileImg = profileView.profileImageView.image
        
        nextButton.isEnabled = isFormValid
        nextButton.isEnabled(isEnabled: isFormValid)
    }
    
    // 캐시 데이터 검증
    func MakePersonalDataInDB() async {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        guard let nickName = userNickName else {
            print("⚠️ 닉네임 설정 안됨.")
            return
        }
        Task {
            do {
                try await PersonalDataManager.shared.createPersonalData(for: userId, userName: nickName)
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .member)
            } catch {
                print(error)
            }
        }
    }
}
