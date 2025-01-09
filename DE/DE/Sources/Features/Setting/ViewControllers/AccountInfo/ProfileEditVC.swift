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
        let profileDTO = networkService.makeMemberInfoUpdateRequestDTO(username: profileView.nicknameTextField.text! , city: profileView.myLocationTextField.text ?? "예시 위치 정보")
        networkService.patchUserInfo(imageName: profileImgFileName, imageData: profileImg!, body: profileDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("프로필 업데이트 완료")
            case .failure(let error):
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary // 사진 라이브러리에서 선택
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // 선택 후 편집 가능
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil) // Picker 닫기
        
        // 이미지를 편집했는지 확인하고, 없으면 원본 이미지 사용
        if let editedImage = info[.editedImage] as? UIImage {
            profileView.profileImageView.image = editedImage
            handleImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileView.profileImageView.image = originalImage
            handleImage(originalImage)
        } else {
            print("이미지를 불러올 수 없습니다.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // Picker 닫기
    }
    
    private func handleImage(_ image: UIImage) {
        // 고유한 파일 이름 생성
        profileImgFileName = "\(UUID().uuidString).jpeg"
        
        // 이미지를 저장하는 추가 작업 수행
        profileImg = image
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
