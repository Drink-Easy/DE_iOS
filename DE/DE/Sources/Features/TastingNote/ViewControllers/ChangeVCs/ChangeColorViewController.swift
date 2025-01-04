// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChangeColorViewController: UIViewController, ColorStackViewDelegate {
    
    var selectedColor: UIColor?
    let chooseWineColor = ChangeColorView()
    let navigationBarManager = NavigationBarManager()
    let noteId: Int
    
    var wineName: String = ""
    var wineSort: String = ""
    var wineArea: String = ""
    var wineImage: String = ""
    
    let noteService = TastingNoteService()
    
    init(noteId: Int) {
        self.noteId = noteId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chooseWineColor.updateUI(wineName: wineName, wineSort: wineSort, imageUrl: wineImage, wineArea: wineArea)
        chooseWineColor.nextButton.isEnabled = false
        chooseWineColor.nextButton.backgroundColor = AppColor.gray30
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDelegate()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.gray20
        
        view.addSubview(chooseWineColor)
        chooseWineColor.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    func setupDelegate() {
        chooseWineColor.colorStackView1.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        guard let selectedColor = selectedColor, let hexColor = selectedColor.toHex() else {
            print("색상을 선택해주세요.")
            return
        }
        
        UserDefaults.standard.set(hexColor, forKey: "color")
        print("선택된 색상 헥스 코드 저장 완료: \(hexColor)")
        
        callNotePatchColor()
        let nextVC = WineInfoViewController(noteId: noteId)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func colorStackView(_ stackView: ColorStackView, didSelectColor color: UIColor?) {
        selectedColor = color
        
        compareColor()
    }
    
    func compareColor() {
        guard let selectedColor = selectedColor, let selectedHexColor = selectedColor.toHex() else { return }
        
        let prevColorHex = UserDefaults.standard.string(forKey: "color")
        
        if selectedHexColor == prevColorHex {
            // 선택된 색상이 이전 색상과 같으면 버튼 비활성화
            chooseWineColor.nextButton.isEnabled = false
            chooseWineColor.nextButton.backgroundColor = AppColor.gray30
        } else {
            // 선택된 색상이 이전 색상과 다르면 버튼 활성화
            chooseWineColor.nextButton.isEnabled = true
            chooseWineColor.nextButton.backgroundColor = AppColor.purple100
        }
    }
    
    func callNotePatchColor() {
        let existingColor = UserDefaults.standard.string(forKey: "color")
        let updateRequest = TastingNoteUpdateRequestDTO(
            color: existingColor,
            tastingDate: nil,
            sugarContent: nil,
            acidity: nil,
            tannin: nil,
            body: nil,
            alcohol: nil,
            addNoseList: nil,
            removeNoseList: nil,
            rating: nil,
            review: nil
        )
        let patchDTO = TastingNotePatchRequestDTO(noteId: noteId, body: updateRequest)
        noteService.patchNote(data: patchDTO, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    print("PATCH 요청 성공: \(response)")
                }
            case.failure(let error):
                print(error)
            }
        })
    }
}
