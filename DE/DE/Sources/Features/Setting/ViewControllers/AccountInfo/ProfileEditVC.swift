// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import PhotosUI

import SnapKit
import Then

import CoreModule
import CoreLocation
import Network

class ProfileEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, FirebaseTrackable {
    var screenName: String = Tracking.VC.profileEditVC
    
    private let navigationBarManager = NavigationBarManager()
    private let imagePickerManager = ImagePickerManager()
    
    private let networkService = MemberService()
    private let errorHandler = NetworkErrorHandler()
    
    private let profileView = ProfileView()
    private let ValidationManager = NicknameValidateManager()
    
    lazy var profileImgFileName: String = ""
    lazy var profileImg: UIImage? = nil
    lazy var imageDeleted: Bool = false
    
    public var profileImgURL: String?
    public var originUsername: String?
    
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
        view.backgroundColor = AppColor.background
        setupUI()
        setupConstraints()
        setupNavigationBar()
        setupImagePicker()
        setupActions()
        configureTapGestureForDismissingPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    // MARK: - 네비게이션 바 설정
    func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "프로필 수정", textColor: AppColor.black)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
        navigationBarManager.addRightButton(
            to: navigationItem,
            title: "완료",
            target: self,
            action: #selector(editCompleteTapped),
            tintColor: AppColor.gray70 ?? .gray,
            font: UIFont.pretendard(.semiBold, size: 16)
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
              let usernameText = self.originUsername else { return }
        let imgURL = URL(string: profileImg)
        self.profileView.profileImageView.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
        self.profileView.nicknameTextField.text = usernameText
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
        }
        
        guard let newUserName = self.profileView.nicknameTextField.text else { return }
        
        let data = networkService.makeMemberInfoUpdateRequestDTO(username: newUserName)
        
        // 병렬 처리
        let _ = try await networkService.patchUserInfoAsync(body: data)
        
    }
    
    @objc private func editCompleteTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.completeProfileUpdateBtnTapped, fileName: #file)
        Task {
            do {
                self.view.showBlockingView()
                try await callPatchAPI()
                self.view.hideBlockingView()
                self.navigationController?.popViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
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
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.startChangeProfileImgBtnTapped, fileName: #file)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // 삭제 로직 구현
            self.logButtonClick(screenName: self.screenName, buttonName: Tracking.ButtonEvent.deleteProfileImgBtnTapped, fileName: #file)
            self.profileImg = nil
            self.profileView.profileImageView.image = UIImage(named: "profilePlaceholder")
            self.imageDeleted = true
        }
        
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.logButtonClick(screenName: self.screenName, buttonName: Tracking.ButtonEvent.changeProfileImgBtnTapped, fileName: #file)
            self.imagePickerManager.presentImagePicker(from: self)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.logButtonClick(screenName: self.screenName, buttonName: Tracking.ButtonEvent.alertCancelBtnTapped, fileName: #file)
        }
        
        // ✅ 액션 추가
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
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
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.fetchLocationBtnTapped, fileName: #file)
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
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.checkDuplicateNicknameBtnTapped, fileName: #file)
        guard let nickname = profileView.nicknameTextField.text, !nickname.isEmpty, ValidationManager.isLengthValid else {
            return
        }
        view.showBlockingView()
        Task {
            await ValidationManager.checkNicknameDuplicate(nickname: nickname, view: profileView.nicknameTextField)
            DispatchQueue.main.async {
                self.view.hideBlockingView()  // ✅ 네트워크 요청 후 인디케이터 중지
                self.checkFormValidity()  // ✅ UI 업데이트
                // 에러 검증 패스
            }
        }
    }
    
    //MARK: - 폼 유효성 검사
    @objc func validateNickname(){
        ValidationManager.isNicknameCanUse = false
        ValidationManager.isLengthValid = false
        if originUsername == profileView.nicknameTextField.text {
            let _ = ValidationManager.noNeedToCheck(profileView.nicknameTextField)
        } else {
            let _ = ValidationManager.validateNickname(profileView.nicknameTextField)
        }
        checkFormValidity()
    }
    
    @objc func checkFormValidity() {
        let isNicknameValid = !(profileView.nicknameTextField.textField.text?.isEmpty ?? true) && ValidationManager.isNicknameCanUse && ValidationManager.isLengthValid
        let isImageSelected = profileView.profileImageView.image != nil
        let isFormValid = isNicknameValid && isImageSelected
        navigationItem.rightBarButtonItem?.isEnabled = isFormValid
    }
}
