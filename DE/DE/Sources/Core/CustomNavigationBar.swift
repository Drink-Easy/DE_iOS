// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class NavigationBarManager {
    
    public init() {
        }
    
    // MARK: - 왼쪽 커스텀 백버튼 생성
    public func addBackButton(to navigationItem: UINavigationItem, target: Any?, action: Selector, tintColor: UIColor = .label) {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = tintColor
        backButton.addTarget(target, action: action, for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - 오른쪽 커스텀 버튼 생성
    public func addRightButton(to navigationItem: UINavigationItem, icon: String, target: Any?, action: Selector, tintColor: UIColor = .label) {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: icon), for: .normal)
        rightButton.tintColor = tintColor
        rightButton.addTarget(target, action: action, for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    // MARK: - 네비게이션 타이틀 설정
    public func setTitle(to navigationItem: UINavigationItem, title: String, textColor: UIColor = .label, font: UIFont = .systemFont(ofSize: 18, weight: .bold)) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
  
    public func addLeftRightButtons(
            to navigationItem: UINavigationItem,
            leftIcon: String,
            leftAction: Selector,
            rightIcon: String,
            rightAction: Selector,
            target: Any?,
            tintColor: UIColor = .label
        ) {
            // 왼쪽 버튼 생성
            let leftButton = UIButton(type: .system)
            leftButton.setImage(UIImage(systemName: leftIcon), for: .normal)
            leftButton.tintColor = tintColor
            leftButton.addTarget(target, action: leftAction, for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)

            // 오른쪽 버튼 생성
            let rightButton = UIButton(type: .system)
            rightButton.setImage(UIImage(systemName: rightIcon), for: .normal)
            rightButton.tintColor = tintColor
            rightButton.addTarget(target, action: rightAction, for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
}
