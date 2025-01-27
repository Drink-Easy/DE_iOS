// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI

import SnapKit
import Then

import CoreModule
import Network

// 테이스팅노트 보기 뷰
public class WineTastingNoteVC: UIViewController, PropertyHeaderDelegate, UIScrollViewDelegate {
    
    let navigationBarManager = NavigationBarManager()
    
    let networkService = TastingNoteService()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    public var noteId: Int = 0
    var wineInfo: TastingNoteResponsesDTO?
    
    //MARK: UI Elements
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.bounces = false
        $0.alwaysBounceVertical = false
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    
    let wineInfoView = WineInfoView()
    
    private var smallTitleLabel = UILabel()
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = wineInfoView.header.header.frame.maxY + 10
        
        UIView.animate(withDuration: 0.1) {
            self.wineInfoView.header.header.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
    
    
    //MARK: Initializers
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        Task {
            do {
                try await CallAllTastingNote()
            } catch {
                print("Error: \(error)")
                // Alert 표시 등 추가
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        wineInfoView.delegate = self
        setupUI()
        setupNavigationBar()
        setNavBarAppearance(navigationController: self.navigationController)
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationBarManager.addLeftRightButtons(
            to: navigationItem,
            leftIcon: "chevron.left",
            leftAction: #selector(prevVC),
            rightIcon: "trash",
            rightAction: #selector(deleteTapped),
            target: self,
            tintColor: AppColor.gray70 ?? .gray)
        
        smallTitleLabel = navigationBarManager.setNReturnTitle(
            to: navigationItem,
            title: wineData.wineName,
            textColor: AppColor.black ?? .black
        )
        smallTitleLabel.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        contentView.addSubview(wineInfoView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 화면 전체에 맞춤
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 가로 크기 고정
            make.bottom.equalTo(wineInfoView.snp.bottom) // 콘텐츠 높이에 맞게 설정
        }
        wineInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    func didTapEditButton(for type: PropertyType) {
            var viewController: UIViewController
            switch type {
                
            //TODO: 수정 뷰컨 연결
            case .palateGraph:
                viewController = ChangePalateVC()
            case .color:
                viewController = EditWineColorViewController()
            case .nose:
                viewController = LoginVC()
            case .rate:
                viewController = EditRateViewController()
            case .review:
                viewController = EditReviewViewController()
            case .none:
                fatalError("Unhandled PropertyType: \(type)")
            }
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteTapped(){
        let alert = UIAlertController(
            title: "테이스팅 노트 삭제",
            message: "정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.noteDelete()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func noteDelete(){
        Task {
            do {
                _ = try await networkService.deleteNote(noteId: noteId)
//                await self.updateCallCount()
                navigationController?.popViewController(animated: true)
            } catch {
                print(error)
            }
        }
        
    }
    
    func updateCallCount() async {
        //        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
        //            print("⚠️ userId가 UserDefaults에 없습니다.")
        //            return
        //        }
        //        Task {
        //            // patch count + 1
        //            do {
        //                try await APICallCounterManager.shared.incrementPatch(for: userId, controllerName: .tastingNote)
        //            } catch {
        //                print(error)
        //            }
        //
        //        }
    }
    
    private func CallAllTastingNote() async throws {
        
        let data = try await networkService.fetchNote(noteId: noteId)
        // Call Count 업데이트
        //        await self.updateCallCount()
        //데이터 매니저에 와인 정보 + 테노 정보 저장
        wineData.updateWineData(wineId: data.wineId, wineName: data.wineName, sort: data.sort, country: data.country, region: data.region, imageUrl: data.imageUrl, variety: data.variety)
        
        tnManager.saveAllData(noteId: noteId,wineId: data.wineId, color: data.color, tasteDate: data.tasteDate, sugarContent: data.sweetness, acidity: data.acidity, tannin: data.tannin, body: data.body, alcohol: data.alcohol, nose: data.noseList, rating: data.rating, review: data.review)
        
        //와인 상세 정보 데이터
        wineInfoView.header.setTitleLabel(data.wineName)
        wineInfoView.header.infoView.image.sd_setImage(with: URL(string: data.imageUrl))
        wineInfoView.header.infoView.kindContents.text = "\(data.sort)"
        wineInfoView.header.infoView.typeContents.text = "\(data.variety)"
        wineInfoView.header.infoView.countryContents.text = "\(data.country), \(data.region)"
        
        //차트 뷰 데이터 로드
        wineInfoView.chartView.viewModel.loadSavedValues(sweetness: Double(data.sweetness), alcohol: Double(data.alcohol), tannin: Double(data.tannin), body: Double(data.body), acidity: Double(data.acidity))
        
        wineInfoView.noseView.text = formatNoseList(data.noseList)
        
        wineInfoView.colorView.backgroundColor = UIColor(hex: data.color)
        wineInfoView.colorLabel.text = WineColorManager().getColorName(for: data.color) ?? "색상 이름 없음"
        
        wineInfoView.ratingValue = data.rating
        wineInfoView.ratingButton.rating = data.rating
        
        wineInfoView.dateView.text = "\(data.tasteDate)에 작성되었어요."
        wineInfoView.reviewView.text = data.review
    }
}
