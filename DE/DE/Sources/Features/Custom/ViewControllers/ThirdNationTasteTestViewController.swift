//
//  ThirdNationTasteTestViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit

class ThirdNationTasteTestViewController: UIViewController {

    var nation: [String] = ["프랑스", "이탈리아", "미국", "칠레", "스페인", "호주", "아르헨티나", "독일", "뉴질랜드", "포르투갈", "오스트리아", "그리스", "슬로베니아", "헝가리", "캐나다", "대한민국", "기타1"]
//    var nationEng: [String] = ["France", "Italy", "United States", "Chile", "Spain", "Australia", "Argentina", "Germany", "New Zealand", "Portugal", "Austria", "Greece", "Slovenia", "Hungary", "Canada", "South Korea", "Other"]
    var selectedIndexPaths: [IndexPath] = []
    private var selectedNations : [String] = []
    
    let nextButton = UIButton(type: .system)
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "제 와인 취향은..."
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(rawValue: 700))
        
        return l
    }()
    
    private let kindLabel: UILabel = {
        let l = UILabel()
        l.text = "국가 (복수선택 가능)"
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.boldSystemFont(ofSize: 20)
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = .white
        setupUI()
    }
    
    lazy var NationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TasteTestSecondCollectionViewCell.self, forCellWithReuseIdentifier: "TasteTestSecondCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        cv.decelerationRate = .fast
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 10
        
        return cv
    }()
    
    private func setupUI() {
        configureNextButton()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
//            make.width.equalTo(338)
//            make.height.equalTo(44)
        }
        
        view.addSubview(kindLabel)
        kindLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(titleLabel)
        }
        
        view.addSubview(NationCollectionView)
        NationCollectionView.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.greaterThanOrEqualTo(443)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.equalTo(60)
        }
    }
    
    private func configureNextButton() {
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        
        nextButton.setImage(UIImage(named: "icon_next"), for: .normal)
        nextButton.imageView?.contentMode = .center
        nextButton.tintColor = .white
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 0)
        
        nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
        nextButton.layer.cornerRadius = 16
        nextButton.layer.borderWidth = 0
    }
    
    private func updateNextButtonState() {
        if selectedIndexPaths.isEmpty {
            // 선택된 셀이 없는 경우
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
            nextButton.removeTarget(nil, action: nil, for: .allEvents)
        } else {
            // 선택된 셀이 하나 이상 있는 경우
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.tintColor = .white
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(hex: "FA735B")
            nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            
            // 선택된 국가 정보 전달
            SelectionManager.shared.setWineNation(anser: selectedNations)
        }
    }
    
    @objc private func nextButtonTapped() {
        let thirdVarietyTasteTestViewController = ThirdVarietyTasteTestViewController()
        navigationController?.pushViewController(thirdVarietyTasteTestViewController, animated: true)
    }

}

extension ThirdNationTasteTestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TasteTestSecondCollectionViewCell", for: indexPath) as! TasteTestSecondCollectionViewCell
            
        cell.configure(imageName: nation[indexPath.item], nationName: nation[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TasteTestSecondCollectionViewCell {
            if cell.View.layer.borderWidth == 0 {
                // 셀이 선택되지 않은 상태였을 때
                cell.View.layer.borderColor = UIColor(hex: "FA8D7B")?.cgColor  // 원하는 색으로 변경
                cell.View.layer.borderWidth = 4  // 테두리 두께 설정
                
                // 선택된 셀의 indexPath를 배열에 추가
                selectedIndexPaths.append(indexPath)
                selectedNations.append(cell.nationEngName)
                
            } else {
                // 셀이 이미 선택된 상태였을 때 (다시 클릭하면 원래대로)
                cell.View.layer.borderWidth = 0
                    
                // 선택 해제된 셀의 indexPath를 배열에서 제거
                if let index = selectedIndexPaths.firstIndex(of: indexPath) {
                    selectedIndexPaths.remove(at: index)
                }
                
                selectedNations = selectedNations.filter{$0 != (cell.nationEngName)}
            }
                
            // nextButton의 상태 업데이트
            updateNextButtonState()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }

}
