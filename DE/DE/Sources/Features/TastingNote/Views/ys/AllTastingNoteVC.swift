//// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule

public class AllTastingNoteVC: UIViewController {
    
    private let tastingNoteView = AllTastingNoteView()
    
    // 더미 데이터
    struct TastingNote {
        let image: String
        let name: String
    }
    let allTastingNoteList: [TastingNote] = [
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold"),
        TastingNote(image: "https://images.unsplash.com/photo-1517685352821-92cf88aee5a5", name: "Coffee - Rich and full-bodied"),
        TastingNote(image: "https://images.unsplash.com/photo-1612392061783-b5e303664f1a", name: "Tea - Delicate and floral"),
        TastingNote(image: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd", name: "Wine - Fruity and bold")
        // ... 더 데이터 추가
    ]
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func loadView() {
        self.view = tastingNoteView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        tastingNoteView.TastingNoteCollectionView.dataSource = self
        tastingNoteView.TastingNoteCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AllTastingNoteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTastingNoteList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TastingNoteCollectionViewCell", for: indexPath) as? TastingNoteCollectionViewCell else {
            fatalError("Unable to dequeue TastingNoteCollectionViewCell")
        }

        let tnItem = allTastingNoteList[indexPath.row]
        if let url = URL(string: tnItem.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                }
            }
        }
        cell.name.text = tnItem.name
        return cell
    }
}
