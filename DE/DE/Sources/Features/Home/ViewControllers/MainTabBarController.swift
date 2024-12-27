// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class MainTabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame
//        tabFrame.size.height = 110
//        tabFrame.origin.y = view.frame.size.height - 105
        tabBar.frame = tabFrame
    }
    
    public func configureTabs() {
        
        let nav1 = UINavigationController(rootViewController: HomeViewController())
        let nav2 = UINavigationController(rootViewController: HomeViewController())
        let nav3 = UINavigationController(rootViewController: HomeViewController())
        let nav4 = UINavigationController(rootViewController: HomeViewController())
        let nav5 = UINavigationController(rootViewController: HomeViewController())
        
        let home = UIImage(named: "TabHome")?.resize(to: CGSize(width: 35, height: 35))
        let cclass = UIImage(named: "TabClass")?.resize(to: CGSize(width: 35, height: 35))
        let note = UIImage(named: "TabNote")?.resize(to: CGSize(width: 35, height: 35))
        let group = UIImage(named: "TabGroup")?.resize(to: CGSize(width: 35, height: 35))
        let setting = UIImage(named: "TabSetting")?.resize(to: CGSize(width: 35, height: 35))

        nav1.tabBarItem = UITabBarItem(title: "홈", image: home, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "클래스", image: cclass, tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "테이스팅 노트", image: note, tag: 2)
        nav4.tabBarItem = UITabBarItem(title: "모임", image: group, tag: 3)
        nav5.tabBarItem = UITabBarItem(title: "설정", image: setting, tag: 4)
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 15)
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = AppColor.purple100
        tabBar.unselectedItemTintColor = AppColor.gray60
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
}
