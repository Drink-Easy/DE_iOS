// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Network

public class WineInfoViewController: UIViewController {
    
    let wineInfoView = WineInfoView()
    private let noteId: Int
    
    let navigationBarManager = NavigationBarManager()
    let noteService = TastingNoteService()
    
    init(noteId: Int) {
        self.noteId = noteId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSelectedNote(noteId: noteId)
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
            tintColor: AppColor.gray90 ?? .black)
    }
    
    func callSelectedNote(noteId: Int) {
        print("NoteID \(noteId)")
        noteService.fetchNote(noteId: noteId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
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
        }
    }
    
    private func setupActions() {
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        let noseTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeNose))
        let rateTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeRate))
        let graphTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeGraph))
        
        wineInfoView.changeColor.addGestureRecognizer(colorTapGesture)
        wineInfoView.changeNose.addGestureRecognizer(noseTapGesture)
        wineInfoView.changeRate.addGestureRecognizer(rateTapGesture)
        wineInfoView.changeGraph.addGestureRecognizer(graphTapGesture)
    }
    
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeColor() {
        let nextVC = ChangeColorViewController(noteId: noteId)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func changeNose() {
        let nextVC = ChangeNoseViewController(noteId: noteId)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func changeRate() {
        let nextVC = ChangeRateViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func changeGraph() {
        let nextVC = ChangeGraphViewController()
        navigationController?.pushViewController(nextVC, animated: true)
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
