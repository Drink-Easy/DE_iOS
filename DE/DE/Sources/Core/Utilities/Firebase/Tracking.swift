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
    
    public struct CellEvent {
        private init() { }
        
        public static let shortSurveyCellTapped = "C1_US 짧은 셀 선택"
        public static let longSurveyCellTapped = "C2_US 긴 셀 선택"
        public static let emojiSurveyCellTapped = "C3_US 이모지 셀 선택"
        
        public static let adBannerCellTapped = "C4_광고 배너 선택"
        public static let recomCellTapped = "C5_더보기 와인 선택"
        public static let homeWineCellTapped = "C6_홈 와인 선택"
        public static let searchWineCellTapped = "C7_검색 와인 선택"
        
        public static let noseCellTapped = "C8_TN 향 선택"
        public static let colorCellTapped = "C9_TN 색상 선택"
        public static let starCellTapped = "C10_TN 별점 선택"
        public static let tnCellTapped = "C11_TN 노트 선택"
        
        public static let settingMenuCellTapped = "C12_단순 메뉴(Text + >) 선택"
        public static let myWineCellTapped = "C13_보유와인 선택"
        public static let noticeCellTapped = "C14_공지사항 선택"
        public static let inquiryCellTapped = "C15_문의하기 선택"
    }
    
    public struct ButtonEvent {
        private init() { }
        /// 버튼 이벤트
        public static let appleBtnTapped = "B1_애플 로그인"
        public static let kakaoBtnTapped = "B2_카카오 로그인"
        public static let loginBtnTapped = "B3_자체 로그인"
        public static let signupBtnTapped = "B4_자체 회원가입"
        public static let toggleBtnTapped = "B5_토글 버튼"
        
        public static let startChangeProfileImgBtnTapped = "B6_프사 설정 버튼 클릭"
        public static let checkDuplicateNicknameBtnTapped = "B7_닉네임 중복 검사 버튼 클릭"
        public static let fetchLocationBtnTapped = "B8_GPS 활성화 버튼 클릭"
        
        public static let goToHomeBtnTapped = "B9_홈으로 가기"
        public static let moreBtnTapped = "B10_더보기"
        public static let likeBtnTapped = "B11_위시리스트"
        public static let tabBarBtnTapped = "B12_탭바 이동하기"
        
        public static let searchBtnTapped = "B13_돋보기"
        public static let sortingBtnTapped = "B14_정렬하기"
        public static let startBtnTapped = "B15_시작하기"
        public static let createBtnTapped = "B16_생성하기"
        public static let nextBtnTapped = "B17_다음"
        public static let saveBtnTapped = "B18_저장하기"
        public static let deleteBtnTapped = "B19_삭제하기"
        public static let editBtnTapped = "B20_수정하기"
        
        public static let tooltipBtnTapped = "B21_툴팁 보기"
        public static let dropdownBtnTapped = "B22_드롭다운"
        
        public static let editProfileBtnTapped = "B23_프로필 수정 시작"
        public static let changeProfileImgBtnTapped = "B24_프사 수정 옵션"
        public static let deleteProfileImgBtnTapped = "B25_프사 삭제 옵션"
        public static let completeProfileUpdateBtnTapped = "B26_프로필 수정 완료"
        
        public static let createNewWineBtnTapped = "B27_보유와인 생성"
        public static let updatemyWineBtnTapped = "B28_보유와인 수정"
        
        public static let instaBtnTapped = "B29_인스타그램 바로가기"
        
        public static let logoutBtnTapped = "B30_로그아웃"
        public static let quitBtnTapped = "B31_탈퇴하기"
        
        public static let alertCancelBtnTapped = "B32_얼럿 취소"
        public static let alertAcceptBtnTapped = "B33_얼럿 확인"
        
        public static let tnRateBtnTapped = "B34_별점 선택"
        
    }
    
    public struct NetworkEvent {
        private init() { }
        
        public static let settingMenuCellTapped = "S1_세팅 메뉴 선택"
        
        public static let logoutBtnTapped = "S2_로그아웃 버튼 클릭"
        public static let quitBtnTapped = "S2_탈퇴하기 버튼 클릭"
        public static let editProfileBtnTapped = "S2_프로필 수정 버튼 클릭"
        
        
    }
}
