// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class SearchResultTableViewCell: UITableViewCell {
    
    private let borderLayer = CALayer()
    
    private lazy var image = UIImageView().then {
        $0.image = UIImage(named: "스파클링")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private lazy var name = UILabel().then {
        $0.text = "루이 로드레 빈티지 브륏"
        $0.textColor = Constants.AppColor.DGblack
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
    }
    
    private lazy var kind = UILabel().then {
        $0.text = "와인 > 스파클링, 샴페인"
        $0.textColor = Constants.AppColor.gray60
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }
    
    private lazy var labelStackView = UIStackView(arrangedSubviews: [name, kind]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private lazy var score = UILabel().then {
        $0.text = "★ 4.0"
        $0.textColor = Constants.AppColor.purple100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = Constants.AppColor.purple10 // 선택된 배경색
            borderLayer.borderColor = Constants.AppColor.purple50?.cgColor // 선택된 테두리색
        } else {
            contentView.backgroundColor = .white // 기본 배경색
            borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addComponents()
        constraints()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.image.image = nil
//        self.name.text = nil
//        self.contents.text = nil
//        self.won.text = nil
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 기본 셀 스타일 설정
        contentView.backgroundColor = .white
        selectionStyle = .none // 기본 선택 스타일 제거
        
        // 테두리 설정
        borderLayer.borderWidth = 1
        borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        borderLayer.frame = contentView.bounds
        contentView.layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = contentView.bounds // 레이아웃 변경 시 테두리 업데이트
    }
    
    private func addComponents() {
        [image, labelStackView, score].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().offset(6)
            $0.width.height.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.equalTo(image)
            $0.leading.equalTo(image.snp.trailing).offset(18)
        }
        
        score.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-6)
            $0.top.equalTo(labelStackView.snp.top)
        }
    }
    
//    public func configure(model: ) {
//        image.image = UIImage(named: model.savedName)
//        name.text = model.savedName
//        contents.text = model.savedContents
//        amount = model.savedAmount
//        won.text = "\(amount)원"
//    }
}
