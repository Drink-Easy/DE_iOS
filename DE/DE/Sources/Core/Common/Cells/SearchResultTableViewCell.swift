// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import SDWebImage

public class SearchResultTableViewCell: UITableViewCell {
    
    private let borderLayer = CALayer()
    
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(hex: "#2f2f2f")
    }
    
    private lazy var image = UIImageView().then {
        $0.image = UIImage(named: "스파클링")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private lazy var name = UILabel().then {
        //$0.text = "루이 로드레 빈티지 브륏"
        $0.textColor = Constants.AppColor.DGblack
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private lazy var kind = UILabel().then {
        //$0.text = "와인 > 스파클링, 샴페인"
        $0.textColor = AppColor.gray100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }
    
    private lazy var labelStackView = UIStackView(arrangedSubviews: [name, kind]).then {
        $0.axis = .vertical
        $0.spacing = 26
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private lazy var score = UILabel().then {
        //$0.text = "★ 4.0"
        $0.textColor = Constants.AppColor.purple100
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            borderLayer.cornerRadius = 8
            contentView.backgroundColor = Constants.AppColor.purple10 // 선택된 배경색
            borderLayer.borderColor = Constants.AppColor.purple70?.cgColor // 선택된 테두리색
            // 1초 후 기본 상태로 복원
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.contentView.backgroundColor = Constants.AppColor.grayBG // 기본 배경색
                self.borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
            }
        } else {
            contentView.backgroundColor = Constants.AppColor.grayBG // 기본 배경색
            borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addComponents()
        constraints()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.image.image = nil
        self.name.text = nil
        self.kind.text = nil
        self.score.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 기본 셀 스타일 설정
        contentView.backgroundColor = Constants.AppColor.grayBG
        selectionStyle = .none // 기본 선택 스타일 제거
        
        // 테두리 설정
        borderLayer.borderWidth = 1
        borderLayer.borderColor = UIColor.clear.cgColor // 기본 테두리 없음
        borderLayer.frame = contentView.bounds
        contentView.layer.addSublayer(borderLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = contentView.bounds // 레이아웃 변경 시 테두리 업데이트
    }
    
    private func addComponents() {
        [imageBackground, labelStackView, score].forEach{ self.addSubview($0) }
        imageBackground.addSubview(image)
    }
    
    private func constraints() {
        
        imageBackground.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(6)
            $0.width.height.equalTo(70)
        }
        
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview()
        }

        labelStackView.snp.makeConstraints {
            $0.centerY.equalTo(imageBackground)
            $0.leading.equalTo(imageBackground.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().offset(-6)
        }
        
        score.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-6)
            $0.centerY.equalTo(kind)
        }
    }
    
    public func configureSearch(model: SearchResultModel, highlightText: String? = nil) {
        if let url = URL(string: model.imageUrl) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        
        //하이라이트 적용
        if let highlightText = highlightText, !highlightText.isEmpty {
            name.attributedText = highlightTextInLabel(text: model.name, highlight: highlightText)
        } else {
            name.text = model.name
        }
    
        kind.text = "와인 > \(model.sort)"
        score.text = "★ \(String(format: "%.1f", model.vivinoRating))"
    }
    
    public func configureWish(model: WishResultModel, highlightText: String? = nil) {
        if let url = URL(string: model.imageUrl) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        
        name.text = model.wineName
    
        kind.text = "와인 > \(model.sort)"
        score.text = "★ \(String(format: "%.1f", model.vivinoRating))"
    }
    
    private func highlightTextInLabel(text: String, highlight: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text.lowercased() as NSString).range(of: highlight.lowercased())
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: AppColor.purple100!, range: range)
            attributedString.addAttribute(.font, value: UIFont.ptdSemiBoldFont(ofSize: 16), range: range)
        }
        return attributedString
    }
}
