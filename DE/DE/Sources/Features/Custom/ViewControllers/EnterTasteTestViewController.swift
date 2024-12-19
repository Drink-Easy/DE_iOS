//
//  EnterTasteTestViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/2/24.
//

import UIKit

class EnterTasteTestViewController: UIViewController {
    
    let startButton = UIButton(type: .system)
    
    private let hiLabel: UILabel = {
        let l = UILabel()
        l.text = "안녕하세요 ,\n만나서 반갑습니다 !"
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(rawValue: 700))
        l.numberOfLines = 0
        
        return l
    }()
    
    private let plzLabel: UILabel = {
        let l = UILabel()
        l.text = "어플을 더욱 알차게 사용하실 수 있게\n저희에게 몇가지 정보를 알려주세요 !"
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 20)
        l.numberOfLines = 0
        
        return l
    }()
    
    private let imageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "EnterTasteTestImg")
        i.backgroundColor = .clear
        return i
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        configureStartButton()
        
        let labelStackView = UIStackView(arrangedSubviews: [hiLabel, plzLabel])
        labelStackView.axis = .vertical
        //buttonStackView.distribution = .fillProportionally
        labelStackView.spacing = 25
        
        view.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(81)
            make.leading.equalToSuperview().offset(27)
//            make.width.equalTo(338)
//            make.height.equalTo(165)
        }
        
        if let image = imageView.image {
            let aspectRatio = image.size.width / image.size.height
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerX.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(imageView.snp.width).dividedBy(aspectRatio)
            }
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.equalTo(60)
        }
    }
    
    private func configureStartButton() {
        startButton.setTitle("시작하기", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentHorizontalAlignment = .center
        
        startButton.backgroundColor = UIColor(hex: "FA735B")
        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 0
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        let whatsURNameViewController = WhatsURNameViewController()
        navigationController?.pushViewController(whatsURNameViewController, animated: true)
    }
}
