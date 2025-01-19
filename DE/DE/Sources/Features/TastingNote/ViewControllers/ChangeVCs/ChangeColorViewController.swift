// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChangeColorViewController: UIViewController {
    
    var selectedColor: UIColor?
//    let chooseWineColor = ChangeColorView()
    let navigationBarManager = NavigationBarManager()
    let dto: TastingNoteResponsesDTO
//    
//    let noteService = TastingNoteService()
//    
    init(dto: TastingNoteResponsesDTO) {
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
//    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        chooseWineColor.updateUI(wineName: dto.wineName, wineSort: dto.sort, imageUrl: dto.imageUrl, wineArea: dto.area)
//        chooseWineColor.nextButton.isEnabled = false
//        chooseWineColor.nextButton.backgroundColor = AppColor.gray30
//    }
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupActions()
//        setupDelegate()
//        setupNavigationBar()
//    }
//    
//    func setupUI() {
//        view.backgroundColor = AppColor.gray20
//        
//        view.addSubview(chooseWineColor)
//        chooseWineColor.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    func setupActions() {
//        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
//    }
//    
//    func setupDelegate() {
//        chooseWineColor.colorStackView1.delegate = self
//    }
//    
//    private func setupNavigationBar() {
//        navigationBarManager.addBackButton(
//            to: navigationItem,
//            target: self,
//            action: #selector(prevVC),
//            tintColor: AppColor.gray80!
//        )
//    }
//    
//    @objc func prevVC() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc func nextVC() {
//
//        callNotePatchColor()
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func colorStackView(_ stackView: ColorStackView, didSelectColor color: UIColor?) {
//        selectedColor = color
//        
//        compareColor()
//    }
//    
//    func compareColor() {
//        guard let selectedColor = selectedColor, let selectedHexColor = selectedColor.toHex() else { return }
//        
//        let prevColorHex = dto.color
//        
//        if selectedHexColor == prevColorHex {
//            // 선택된 색상이 이전 색상과 같으면 버튼 비활성화
//            chooseWineColor.nextButton.isEnabled = false
//            chooseWineColor.nextButton.backgroundColor = AppColor.gray30
//        } else {
//            // 선택된 색상이 이전 색상과 다르면 버튼 활성화
//            chooseWineColor.nextButton.isEnabled = true
//            chooseWineColor.nextButton.backgroundColor = AppColor.purple100
//        }
//    }
//    
//    func callNotePatchColor() {
//        let existingColor = selectedColor?.toHex()
//        let updateRequest = TastingNoteUpdateRequestDTO(
//            color: existingColor,
//            tastingDate: nil,
//            sugarContent: nil,
//            acidity: nil,
//            tannin: nil,
//            body: nil,
//            alcohol: nil,
//            addNoseList: nil,
//            removeNoseList: nil,
//            rating: nil,
//            review: nil
//        )
//        let patchDTO = TastingNotePatchRequestDTO(noteId: dto.noteId, body: updateRequest)
//        noteService.patchNote(data: patchDTO, completion: {[weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case.success(let response):
//                DispatchQueue.main.async {
//                    print("PATCH 요청 성공: \(response)")
//                }
//            case.failure(let error):
//                print(error)
//            }
//        })
//    }
}
