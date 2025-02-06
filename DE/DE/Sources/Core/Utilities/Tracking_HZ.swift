// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct Tracking {
    private init() { }
    
    public struct VC {
        private init() { }
        
        //MARK: - Auth
        public static let splashVC = "A1_스플래시"
        public static let onboardingVC = "A2_온보딩"
        public static let selectLoginTypeVC = "A3_로그인 타입 선택"
        public static let signUpVC = "A4_회원가입"
        public static let loginVC = "A5_로그인"
        public static let termsOfServiceVC = "A6_이용약관"
        
        //MARK: - UserSurvey
        public static let WelcomeVC = "U1_취향찾기 완전 첫 화면"
        public static let GetProfileVC = "U2_프로필 초기 설정"
        public static let IsNewbieVC = "U3_뉴비/마니아 선택"
        
        public static let ManiaConsumeVC = "U4_마니아 소비 선택"
        public static let ManiaKindVC = "U5_마니아 와인 종류 선택"
        public static let ManiaTypeVC = "U6_마니아 와인 품종 선택"
        public static let ManiaCountryVC = "U7_마니아 와인 생산국 선택"
        
        public static let NewbieEnjoyDrinkingVC = "U8_뉴비 즐겨마시는 주종"
        public static let NewbieFoodVC = "U9_뉴비 즐겨먹는 안주"
        public static let NewbieConsumeVC = "U10_뉴비 원하는 가격"
        public static let NormalTextVC = "U11_뉴비 추천 결과"
        
        //MARK: - Home
        public static let homeViewController = "H1_홈"
        public static let moreLikelyWineVC = "H2_추천 와인 더보기"
        public static let morePopularWineVC = "H3_인기있는 와인 더보기"
        
        public static let searchHomeVC = "H4_홈 와인 검색"
        public static let wineDetailVC = "H5_와인 상세 정보"
        public static let entireReviewVC = "H6_와인 리뷰 더보기"
        
        //MARK: - TastingNote
        public static let allTastingNoteVC = "T1_노트 보관함"
        public static let wineTastingNoteVC = "T2_TN 상세보기"
        
        public static let tnSearchWineVC = "T3_TN 생성 검색"
        public static let tnTastedDateVC = "T4_TN 생성 날짜"
        public static let tnChooseWineColorVC = "T5_TN 생성 컬러"
        public static let tnChooseNoseVC = "T6_TN 생성 향"
        public static let tnRecordGraphVC = "T7_TN 생성 팔렛"
        public static let tnRatingWineVC = "T8_TN 생성 별점 리뷰"
        
        public static let editPalateVC = "T9_TN 수정 팔렛"
        public static let editWineColorVC = "T10_TN 수정 컬러"
        public static let editNoseVC = "T11_TN 수정 향"
        public static let editRateVC = "T12_TN 수정 별점"
        public static let editReviewVC = "T13_TN 수정 리뷰"
        
        //MARK: - Settings
        public static let settingMainVC = "S1_세팅 메인"
        public static let accountInfoVC = "S2_계정 정보"
        public static let profileEditVC = "S3_프로필 수정"
        public static let wishlistVC = "S4_위시리스트 목록"
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
