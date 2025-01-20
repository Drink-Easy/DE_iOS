// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Network

public class WineInfoViewController: UIViewController {
    
    let wineInfoView = WineInfoView()
    public let noteId: Int
    let navigationBarManager = NavigationBarManager()
    let noteService = TastingNoteService()
    var changeNoseData: [String: String] = [:]
    
    var dto: TastingNoteResponsesDTO?
    
    public init(noteId: Int) {
        self.noteId = noteId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        chartView.propertyHeader.setName(eng: "Palate", kor: "맛")
//        recordGraphView.propertyHeader.setName(eng: "Graph Record", kor: "그래프 상세 기록")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.callSelectedNote(noteId: self.noteId)
        }
    }
    
    
    func setupUI() {
        view.addSubview(wineInfoView)
        wineInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addLeftRightButtons(
            to: navigationItem,
            leftIcon: "chevron.left",
            leftAction: #selector(prevVC),
            rightIcon: "trash",
            rightAction: #selector(deleteTapped),
            target: self,
            tintColor: AppColor.gray70 ?? .gray)
    }
    
    func callSelectedNote(noteId: Int) {
        print("NoteID \(noteId)")
        noteService.fetchNote(noteId: noteId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                dto = data
                handleSelectedNoteResponse(data)
            case.failure(let error):
                print(error)
            }
        })
    }
    
    private func handleSelectedNoteResponse(_ data: TastingNoteResponsesDTO) {
        DispatchQueue.main.async {
            print("Fetched Note Data:", data)
            self.wineInfoView.updateUI(data)
            
            let noseMap = data.noseMapList.reduce(into: [String: String]()) { dict, item in
                if let key = item.keys.first, let value = item.values.first {
                    dict[key] = value
                }
            }
            
            self.changeNoseData = noseMap
        }
    }
    
    private func setupActions() {
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        let noseTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeNose))
        let rateTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeRate))
        let graphTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeGraph))
        
//        wineInfoView.changeColor.addGestureRecognizer(colorTapGesture)
//        wineInfoView.changeNose.addGestureRecognizer(noseTapGesture)
//        wineInfoView.changeRate.addGestureRecognizer(rateTapGesture)
//        wineInfoView.changeGraph.addGestureRecognizer(graphTapGesture)
    }
    
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeColor() {
        guard let dto = dto else {
            print("DTO is nil")
            return
        }
        
        let nextVC = ChangeColorViewController(dto: dto)
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func changeNose() {
        guard let dto = dto else {
            print("DTO is nil")
            return
        }
        
        let nextVC = ChangeNoseViewController(dto: dto)
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func changeRate() {
        guard let dto = dto else {
            print("DTO is nil")
            return
        }
        
        let nextVC = ChangeRateViewController(dto: dto)
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func changeGraph() {
        guard let dto = dto else {
            print("DTO is nil")
            return
        }
        
        let nextVC = ChangeGraphViewController(dto: dto)
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func deleteTapped() {
        noteService.deleteNote(noteId: noteId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                print(response)
            case.failure(let error):
                print(error)
            }
        })
    }
}
