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
    
    // MARK: - 커스텀 Large Title
//    public func setupCustomLargeTitle(for navigationController: UINavigationController?, title: String, font: UIFont, textColor: UIColor, lineSpacing: CGFloat) {
//        
//        guard let navBar = navigationController?.navigationBar else { return }
//        
//        let largeTitleLabel = UILabel()
//        largeTitleLabel.text = title
//        largeTitleLabel.numberOfLines = 0  // 여러 줄 허용
//        largeTitleLabel.font = font
//        largeTitleLabel.textAlignment = .left
//        
//        //줄 간격 설정 (lineSpacing 적용)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        let attributedText = NSAttributedString(
//            string: title,
//            attributes: [
//                .font: largeTitleLabel.font!,
//                .paragraphStyle: paragraphStyle
//            ]
//        )
//        largeTitleLabel.attributedText = attributedText
//        
//        // 커스텀 뷰 컨테이너 생성
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.largeTitleTextAttributes = [
//                .foregroundColor: UIColor.label,
//                .font: UIFont.boldSystemFont(ofSize: 34),
//                .paragraphStyle: paragraphStyle
//            ]
//            navBar.scrollEdgeAppearance = appearance
//            navBar.standardAppearance = appearance
//        }
//        
//        // 타이틀 설정
//        navBar.topItem?.title = title
//    }
}
