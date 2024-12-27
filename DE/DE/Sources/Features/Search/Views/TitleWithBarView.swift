// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class TitleWithBarView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        $0.textColor = Constants.AppColor.DGblack
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = Constants.AppColor.gray80
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = Constants.AppColor.purple50
    }

    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        backgroundColor = Constants.AppColor.grayBG
        setupView()
        setupConstraints()

        titleLabel.text = title
        subTitleLabel.text = subTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        [titleLabel, subTitleLabel, separatorView].forEach{ self.addSubview($0) }
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }

        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
