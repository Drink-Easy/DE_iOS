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
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
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
    
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
}
