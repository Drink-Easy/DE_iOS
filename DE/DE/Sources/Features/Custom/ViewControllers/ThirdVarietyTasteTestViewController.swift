//
//  ThirdVarietyTasteTestViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit
import Moya
 
class ThirdVarietyTasteTestViewController: UIViewController {
    var variety: [String] = ["까베르네소비뇽", "샤도네이", "메를로", "까베르네프랑", "피노누아", "쉬라즈", "쇼비뇽 블랑", "그르나슈", "말벡", "산지오베제", "모스카토", "리슬링", "템프라니요", "네비올로", "블랜드", "쁘띠베르도", "무르베드르", "카르메너르", "기타"]
    var selectedIndexPaths: [IndexPath] = []
    private var selectedVariety : [String] = []
    var memberInfoDTO : MemberInfoRequest?
    
    let startButton = UIButton(type: .system)
    
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
        l.text = "품종 (복수선택 가능)"
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.boldSystemFont(ofSize: 20)
        return l
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = .white
        setupUI()
    }
    
    lazy var VarietyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TasteTestThirdCollectionViewCell.self, forCellWithReuseIdentifier: "TasteTestThirdCollectionViewCell")
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
        configureStartButton()
        
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
        
        view.addSubview(VarietyCollectionView)
        VarietyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.greaterThanOrEqualTo(443)
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
        
        startButton.backgroundColor = UIColor(hex: "#E2E2E2")
        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 0
    }
    
    private func updateStartButtonState() {
        if selectedIndexPaths.isEmpty {
            // 선택된 셀이 없는 경우
            startButton.isEnabled = false
            startButton.backgroundColor = UIColor(hex: "#E2E2E2")
            startButton.removeTarget(nil, action: nil, for: .allEvents)
        } else {
            // 선택된 셀이 하나 이상 있는 경우
            startButton.setTitleColor(.white, for: .normal)
            startButton.tintColor = .white
            startButton.isEnabled = true
            startButton.backgroundColor = UIColor(hex: "FA735B")
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            
            SelectionManager.shared.setWineVariety(anser: selectedVariety)
        }
    }
    
    @objc private func startButtonTapped() {
        assignRequestDTO()
        callAPI() { [weak self] isSuccess in
            if isSuccess {
                self?.goToHomeView()
            } else {
                print("유저 정보 전송 실패")
            }
        }
    }
    
    private func goToHomeView() {
        let mainTabBarViewController = MainTabBarViewController()
        navigationController?.pushViewController(mainTabBarViewController, animated: true)
    }
    
    //MARK: - API parts
    let provider = MoyaProvider<MemberInfoAPI>(plugins: [CookiePlugin()])
    
    func assignRequestDTO() {
            let selectionMng = SelectionManager.shared
            self.memberInfoDTO = MemberInfoRequest(
                isNewbie: selectionMng.isNewbie,
                monthPrice: selectionMng.monthPrice,
                wineSort: selectionMng.wineSort,
                wineArea: selectionMng.wineNation,
                wineVariety: selectionMng.wineVariety,
                region: selectionMng.userAddr,
                name: selectionMng.userName
            )
        }
        
        func callAPI(completion: @escaping (Bool) -> Void) {
            if let data = self.memberInfoDTO {
                provider.request(.patchMember(data: data)) { result in
//                    print(data)
                    switch result {
                    case .success(let response):
                        do {
                            let data = try response.map(APIResponseMemberResponse.self)
//                            print("Success: \(data)")
                            LoginViewController.isFirstLogin = false
                            completion(data.isSuccess)
                        } catch {
                            print("Failed to map data: \(error)")
                            completion(false)
                        }
                    case .failure(let error):
                            print("Request failed: \(error)")
                            completion(false)
                    }
                }
            } else {
                print("유저 선택 정보가 없습니다.")
                completion(false)
            }
        }
    
}

extension ThirdVarietyTasteTestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variety.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TasteTestThirdCollectionViewCell", for: indexPath) as! TasteTestThirdCollectionViewCell
            
        cell.configure(name: variety[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TasteTestThirdCollectionViewCell {
            if cell.View.backgroundColor == .white || cell.View.backgroundColor == UIColor(hex: "E6E6E6") {
                // 셀이 선택되지 않은 상태였을 때
                cell.View.backgroundColor = UIColor(hex: "FBCBC4")
                cell.View.layer.borderColor = UIColor(hex: "FA8D7B")?.cgColor  // 원하는 색으로 변경
                
                // 선택된 셀의 indexPath를 배열에 추가
                selectedIndexPaths.append(indexPath)
                selectedVariety.append(cell.name.text ?? "")
            } else {
                // 셀이 이미 선택된 상태였을 때 (다시 클릭하면 원래대로)
                if (cell.name.text == "기타") {
                    cell.View.backgroundColor = UIColor(hex: "E6E6E6")
                } else {
                    cell.View.backgroundColor = .white
                }
                cell.View.layer.borderColor = UIColor(hex: "C3C3C3")?.cgColor
                    
                // 선택 해제된 셀의 indexPath를 배열에서 제거
                if let index = selectedIndexPaths.firstIndex(of: indexPath) {
                    selectedIndexPaths.remove(at: index)
                }
                selectedVariety = selectedVariety.filter{$0 != (cell.name.text ?? "")}
            }
                
            // nextButton의 상태 업데이트
            updateStartButtonState()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 33)
    }
}
