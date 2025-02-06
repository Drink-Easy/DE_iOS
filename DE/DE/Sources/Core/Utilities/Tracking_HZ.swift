// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct Tracking {
    private init() { }
    
    public struct VC {
        private init() { }
        
        
        
        //MARK: - Settings
        public static let settingMainVC = "S1_세팅 메인"
        public static let accountInfoVC = "S2_계정 정보"
        public static let profileEditVC = "S3_프로필 수정"
        
        public static let wishListVC = "S4_위시리스트 목록"
        
        public static let myWineVC = "S5_보유와인 목록"
        public static let myWineDetailVC = "S6_보유와인 상세"
        public static let createMyWineVC = "S7_보유와인 생성"
        public static let updateMyWineVC = "S8_보유와인 수정"
        public static let setMyWineDateVC = "S9_보유와인 날짜 선택"
        public static let setMyWinePriceVC = "S10_보유와인 가격 입력"
        
        public static let noticeVC = "S11_공지사항 목록"
        public static let appInfoVC = "S12_앱 정보"
        public static let inquiryVC = "S13_문의하기"
    }
}
