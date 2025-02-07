// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class CrashViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCrashButton()
    }
    
    private func setupCrashButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 50, width: 150, height: 40)
        button.setTitle("Test Crash", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(crashButtonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func crashButtonTapped() {
        let numbers = [0]
        let _ = numbers[1]  // ❌ 존재하지 않는 index 접근 → 크래시 발생
    }
}
