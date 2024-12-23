//
//  SearchHomeViewController.swift
//  Drink-EG
//
//  Created by 김도연 on 7/20/24.
//

import UIKit
import SnapKit
import Moya
import SDWebImage
import SwiftyToaster

class SearchHomeViewController : UIViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F8F8FA")
        self.view = searchHomeView
    }
    
    public lazy var searchHomeView: SearchHomeView = {
        let v = SearchHomeView()
        return v
    }()
}
