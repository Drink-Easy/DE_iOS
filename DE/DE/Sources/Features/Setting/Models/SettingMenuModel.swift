// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

struct SettingMenuModel {
    let name: String
    let viewControllerType: UIViewController.Type // 뷰컨트롤러의 타입 저장
}

struct SettingMenuItems {
    public static let accountInfo = SettingMenuModel(name: "계정 정보", viewControllerType: AccountInfoViewController.self)
    public static let wishList = SettingMenuModel(name: "위시리스트", viewControllerType: WishListViewController.self)
    public static let ownedWine = SettingMenuModel(name: "내 보유 와인", viewControllerType: MyOwnedWineViewController.self)
//    public static let schedule = SettingMenuModel(name: "내 모임 일정", viewControllerType: MyPartyScheduleViewController.self)
    public static let notice = SettingMenuModel(name: "공지사항", viewControllerType: NoticeViewController.self)
    public static let appInfo = SettingMenuModel(name: "앱 정보", viewControllerType: AppInfoViewController.self)
    public static let inquiry = SettingMenuModel(name: "1:1 문의하기", viewControllerType: InquiryViewController.self)
}

