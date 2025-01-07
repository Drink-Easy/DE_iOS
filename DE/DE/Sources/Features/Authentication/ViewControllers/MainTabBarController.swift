// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import TastingNote
import CommunityModule
import HomeModule

public class MainTabBarController: UITabBarController {
    
    let homeVC = HomeViewController()
    let classVC = HomeViewController()
    
    public var userName: String? {
        didSet {
            updateUserName()
        }
    }

    private func updateUserName() {
        if let name = userName {
            print("✅ 닉네임 업데이트: \(name)")
            homeVC.userName = name
            classVC.userName = name
        } else {
            guard let userId = UserDefaults.standard.object(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 저장되어 있지 않습니다.")
                return
            }
            
            Task {
                if let userData = await UserDataManager.shared.fetchUser(userId: userId) {
                    print("✅ SwiftData에서 닉네임 가져오기 성공")
                    homeVC.userName = userData.userName
                    classVC.userName = userData.userName
                } else {
                    print("⚠️ SwiftData에서 닉네임을 찾을 수 없습니다.")
                    homeVC.userName = "noname"
                    classVC.userName = "noname"
                }
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureTabs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabFrame = tabBar.frame
        tabBar.frame = tabFrame
    }
    
    public func configureTabs() {
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: classVC)
        let nav3 = UINavigationController(rootViewController: NoteListViewController())
        let nav4 = UINavigationController(rootViewController: CommunityVC())
        let nav5 = UINavigationController(rootViewController: LogoutTestVC())
        
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
// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 현재 선택된 탭이 다시 선택되었을 때만 처리
        guard let navController = viewController as? UINavigationController else { return }
        
        // 루트 뷰로 이동
        navController.popToRootViewController(animated: true)
    }
}
