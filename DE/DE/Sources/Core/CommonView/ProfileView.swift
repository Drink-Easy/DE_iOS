// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class ProfileView: UIView {
    
    public let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profilePlaceholder")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    
    public let profileImageEditButton = UIButton().then {
        $0.backgroundColor = AppColor.purple100
        $0.layer.cornerRadius = 15
    }
    
    public let profileImageIconView = UIImageView().then {
        let iconImage = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        $0.image = iconImage
        $0.tintColor = .white
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    public let nicknameTextField = CustomTextFieldView(
        descriptionLabelText: "닉네임",
        textFieldPlaceholder: "닉네임을 입력해 주세요",
        validationText: ""
    )
    
    public let checkDuplicateButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(AppColor.gray70, for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 12)
    }
    
    public let myLocationTextField = CustomTextFieldView(
        descriptionLabelText: "내 동네",
        textFieldPlaceholder: "",
        validationText: ""
    ).then {
        $0.textField.isUserInteractionEnabled = false
    }
    
    public let locationImageIconButton = UIButton().then {
        let iconImage = UIImage(named: "MyLocation")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(iconImage, for: .normal)
        $0.tintColor = AppColor.gray70
        $0.imageView?.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = AppColor.gray30
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [profileImageView, profileImageEditButton, profileImageIconView, nicknameTextField, checkDuplicateButton, myLocationTextField, locationImageIconButton].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
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
        checkDuplicateButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.trailing.equalToSuperview().inset(24)
        }
        myLocationTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(72)
        }
        locationImageIconButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalTo(myLocationTextField.snp.trailing).offset(8)
            make.bottom.equalTo(myLocationTextField.snp.bottom)
        }
    }
}
