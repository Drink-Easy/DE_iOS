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
    lazy var imageDeleted: Bool = false
    
    public var profileImgURL: String?
    public var originUsername: String?
    public var originUserCity: String?
    
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
        navigationBarManager.setTitle(to: navigationItem, title: "프로필 수정", textColor: AppColor.black!)
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
            self.profileView.profileImageView.image = image
            self.profileImgFileName = fileName
            self.profileImg = image
        }
    }
    
    // MARK: UI Component 설정
    func setupUI() {
        view.addSubview(profileView)
        view.addSubview(indicator)
        guard let profileImg = self.profileImgURL,
              let usernameText = self.originUsername,
              let usercityText = self.originUserCity else { return }
        let imgURL = URL(string: profileImg)
        self.profileView.profileImageView.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
        self.profileView.nicknameTextField.text = usernameText
        self.profileView.myLocationTextField.text = usercityText
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
    
    private func callPatchAPI() async throws {
        if let profileImg = self.profileImg {
            let _ = try await networkService.postImgAsync(image: profileImg)
        } else if imageDeleted == true {
            let _ = try await networkService.deleteProfileImage()
        } else { return }
        
        guard let newUserName = self.profileView.nicknameTextField.text,
              let newUserCity = self.profileView.myLocationTextField.text else { return }
        
        let data = networkService.makeMemberInfoUpdateRequestDTO(username: newUserName, city: newUserCity)
        
        // 병렬 처리
        let _ = try await networkService.patchUserInfoAsync(body: data)
        
        // Call Count 업데이트
        await self.updateCallCount()
    }
    
    @objc private func editCompleteTapped() {
        Task {
            do {
                self.view.showBlockingView()
                try await callPatchAPI()
                self.view.hideBlockingView()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error: \(error)")
                self.view.hideBlockingView()
                // Alert 표시 등 추가
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
    
    func showProfileActionSheet(in viewController: UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // 삭제 로직 구현
            self.profileImg = nil
            self.profileView.profileImageView.image = UIImage(named: "profilePlaceholder")
            self.imageDeleted = true
        }
        
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.imagePickerManager.presentImagePicker(from: self)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("❌ 취소 버튼 눌림")
        }
        
        // ✅ 액션 추가
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelAction)

        // ✅ 액션 시트 표시
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    // 프로필 이미지 선택
    @objc func selectProfileImage() {
        showProfileActionSheet(in: self)
    }
    
    //MARK: - 위치 정보 불러오기 로직
    @objc func getMyLocation() {
        self.view.showBlockingView()
        LocationManager.shared.requestLocationPermission { [weak self] address in
            DispatchQueue.main.async {
                self?.profileView.myLocationTextField.textField.text = address ?? ""
                self?.view.hideBlockingView()
            }
        }
    }
    
    //MARK: - 닉네임 중복 검사
    @objc func checkNicknameValidity(){
        
        guard let nickname = profileView.nicknameTextField.text, !nickname.isEmpty, ValidationManager.isLengthValid else {
            print("닉네임이 없습니다")
            return
        }
        view.showBlockingView()
        Task {
            await ValidationManager.checkNicknameDuplicate(nickname: nickname, view: profileView.nicknameTextField)
            DispatchQueue.main.async {
                self.view.hideBlockingView()  // ✅ 네트워크 요청 후 인디케이터 중지
                self.checkFormValidity()  // ✅ UI 업데이트
            }
        }
    }
    
    //MARK: - 폼 유효성 검사
    @objc func validateNickname(){
        ValidationManager.isNicknameCanUse = false
        ValidationManager.isLengthValid = false
        if originUsername == profileView.nicknameTextField.text {
            ValidationManager.noNeedToCheck(profileView.nicknameTextField)
        } else {
            ValidationManager.validateNickname(profileView.nicknameTextField)
        }
        checkFormValidity()
    }
    
    @objc func checkFormValidity() {
        let isNicknameValid = !(profileView.nicknameTextField.textField.text?.isEmpty ?? true) && ValidationManager.isNicknameCanUse && ValidationManager.isLengthValid
        let isLocationValid = !(profileView.myLocationTextField.textField.text?.isEmpty ?? true)
        let isImageSelected = profileView.profileImageView.image != nil
        let isFormValid = isNicknameValid && isLocationValid && isImageSelected
        navigationItem.rightBarButtonItem?.isEnabled = isFormValid
    }
}
