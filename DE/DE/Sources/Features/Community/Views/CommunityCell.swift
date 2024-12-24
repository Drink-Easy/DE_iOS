// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit
import Then
import SDWebImage
import CoreModule

class CommunityCell: UICollectionViewCell {
    // MARK: - Reuse Identifier
    static let reuseIdentifier = "CommunityCell"
    
    // MARK: - UI Components
    private let pieceView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let sideBar = UIView().then {
        $0.backgroundColor = .white
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
    }

    private let bookmarkIcon = UIImageView().then {
        $0.image = UIImage(systemName: "bookmark")?.withTintColor(AppColor.gray60 ?? .gray, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleAspectFill
    }

    let timeIconLabel = IconLabelView()
    let locationIconLabel = IconLabelView()
    let peopleIconLabel = IconLabelView()
    let priceIconLabel = IconLabelView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(pieceView)
        pieceView.addSubview(imageView)
        pieceView.addSubview(sideBar)
        [titleLabel, bookmarkIcon, timeIconLabel, locationIconLabel, peopleIconLabel, priceIconLabel].forEach {
            sideBar.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        pieceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        sideBar.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        bookmarkIcon.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        peopleIconLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        priceIconLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleIconLabel)
            make.leading.equalTo(peopleIconLabel.snp.trailing).offset(8)
        }
        locationIconLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleIconLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        timeIconLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIconLabel)
            make.leading.equalTo(locationIconLabel.snp.trailing).offset(8)
        }
    }
    
    // MARK: - Configuration
    func configure(mediaURL: String, title: String, memberCount: String, price: String, location: String, createdAt: String) {
        titleLabel.text = title
        timeIconLabel.configure(systemName: "calendar", labelText: createdAt)
        locationIconLabel.configure(systemName: "mappin.and.ellipse", labelText: location)
        peopleIconLabel.configure(systemName: "person.fill", labelText: memberCount)
        priceIconLabel.configure(systemName: "wonsign.circle.fill", labelText: price)
        if let imageUrl = URL(string: mediaURL) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "pieceImagePlaceholder"))
        }
    }
}
