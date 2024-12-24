//
//  RecordGraphViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit

public class RecordGraphViewController: UIViewController {

    let recordGraphView = RecordGraphView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordGraphView
    }

}
