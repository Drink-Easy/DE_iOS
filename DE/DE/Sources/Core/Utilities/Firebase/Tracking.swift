// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct Tracking {
    private init() { }
    
    public struct VC {
        private init() { }
        
        //MARK: - Auth
        public static let splashVC = "A1 스플래시"
        public static let onboardingVC = "A2 온보딩"
        public static let selectLoginTypeVC = "A3 로그인 타입 선택"
        public static let signUpVC = "A4 회원가입"
        public static let loginVC = "A5 로그인"
        public static let termsOfServiceVC = "A6 이용약관"
        
        //MARK: - UserSurvey
        public static let WelcomeVC = "U1 취향찾기 완전 첫 화면"
        public static let GetProfileVC = "U2 프로필 초기 설정"
        public static let IsNewbieVC = "U3 뉴비/마니아 선택"
        
        public static let ManiaConsumeVC = "U4 마니아 소비 선택"
        public static let ManiaKindVC = "U5 마니아 와인 종류 선택"
        public static let ManiaTypeVC = "U6 마니아 와인 품종 선택"
        public static let ManiaCountryVC = "U7 마니아 와인 생산국 선택"
        
        public static let NewbieEnjoyDrinkingVC = "U8 뉴비 즐겨마시는 주종"
        public static let NewbieFoodVC = "U9 뉴비 즐겨먹는 안주"
        public static let NewbieConsumeVC = "U10 뉴비 원하는 가격"
        public static let NormalTextVC = "U11 뉴비 추천 결과"
        
        //MARK: - Home
        public static let homeViewController = "H1 홈"
        public static let moreLikelyWineVC = "H2 추천 와인 더보기"
        public static let morePopularWineVC = "H3 인기있는 와인 더보기"
        
        public static let searchHomeVC = "H4 홈 와인 검색"
        public static let wineDetailVC = "H5 와인 상세 정보"
        public static let entireReviewVC = "H6 와인 리뷰 더보기"
        
        //MARK: - TastingNote
        public static let allTastingNoteVC = "T1 노트 보관함"
        public static let wineTastingNoteVC = "T2 TN 상세보기"
        
        public static let tnSearchWineVC = "T3 TN 생성 검색"
        public static let tnTastedDateVC = "T4 TN 생성 날짜"
        public static let tnChooseWineColorVC = "T5 TN 생성 컬러"
        public static let tnChooseNoseVC = "T6 TN 생성 향"
        public static let tnRecordGraphVC = "T7 TN 생성 팔렛"
        public static let tnRatingWineVC = "T8 TN 생성 별점 리뷰"
        
        public static let editPalateVC = "T9 TN 수정 팔렛"
        public static let editWineColorVC = "T10 TN 수정 컬러"
        public static let editNoseVC = "T11 TN 수정 향"
        public static let editRateVC = "T12 TN 수정 별점"
        public static let editReviewVC = "T13 TN 수정 리뷰"
        
        //MARK: - Settings
        public static let settingMainVC = "S1 세팅 메인"
        public static let accountInfoVC = "S2 계정 정보"
        public static let profileEditVC = "S3 프로필 수정"
        public static let wishlistVC = "S4 위시리스트 목록"
        public static let myWineVC = "S5 보유와인 목록"
        public static let myWineDetailVC = "S6 보유와인 상세"
        public static let createMyWineVC = "S7 보유와인 생성"
        public static let updateMyWineVC = "S8 보유와인 수정"
        public static let setMyWineDateVC = "S9 보유와인 날짜 선택"
        public static let setMyWinePriceVC = "S10 보유와인 가격 입력"
        
        public static let noticeVC = "S11 공지사항 목록"
        public static let appInfoVC = "S12 앱 정보"
        public static let inquiryVC = "S13 문의하기"
    }
    
    public struct CellEvent {
        private init() { }
        
        public static let shortSurveyCellTapped = "C1 US 짧은 셀 선택"
        public static let longSurveyCellTapped = "C2 US 긴 셀 선택"
        public static let emojiSurveyCellTapped = "C3 US 이모지 셀 선택"
        
        public static let adBannerCellTapped = "C4 광고 배너 선택"
        public static let recomCellTapped = "C5 더보기 와인 선택"
        public static let homeWineCellTapped = "C6 홈 와인 선택"
        public static let searchWineCellTapped = "C7 검색 와인 선택"
        
        public static let noseCellTapped = "C8 TN 향 선택"
        public static let colorCellTapped = "C9 TN 색상 선택"
        public static let starCellTapped = "C10 TN 별점 선택"
        public static let tnCellTapped = "C11 TN 노트 선택"
        
        public static let settingMenuCellTapped = "C12 단순 메뉴(Text + >) 선택"
        public static let myWineCellTapped = "C13 보유와인 선택"
        public static let noticeCellTapped = "C14 공지사항 선택"
        public static let inquiryCellTapped = "C15 문의하기 선택"
    }
    
    public struct ButtonEvent {
        private init() { }
        /// 버튼 이벤트
        public static let appleBtnTapped = "B1 애플 로그인"
        public static let kakaoBtnTapped = "B2 카카오 로그인"
        public static let loginBtnTapped = "B3 자체 로그인"
        public static let signupBtnTapped = "B4 자체 회원가입"
        public static let toggleBtnTapped = "B5 토글 버튼"
        
        public static let startChangeProfileImgBtnTapped = "B6 프사 설정 버튼 클릭"
        public static let checkDuplicateNicknameBtnTapped = "B7 닉네임 중복 검사 버튼 클릭"
        public static let fetchLocationBtnTapped = "B8 GPS 활성화 버튼 클릭"
        
        public static let goToHomeBtnTapped = "B9 홈으로 가기"
        public static let moreBtnTapped = "B10 더보기"
        public static let likeBtnTapped = "B11 위시리스트"
        public static let tabBarBtnTapped = "B12 탭바 이동하기"
        
        public static let searchBtnTapped = "B13 돋보기"
        public static let sortingBtnTapped = "B14 정렬하기"
        public static let startBtnTapped = "B15 시작하기"
        public static let createBtnTapped = "B16 생성하기"
        public static let nextBtnTapped = "B17 다음"
        public static let saveBtnTapped = "B18 저장하기"
        public static let deleteBtnTapped = "B19 삭제하기"
        public static let editBtnTapped = "B20 수정하기"
        
        public static let tooltipBtnTapped = "B21 툴팁 보기"
        public static let dropdownBtnTapped = "B22 드롭다운"
        
        public static let editProfileBtnTapped = "B23 프로필 수정 시작"
        public static let changeProfileImgBtnTapped = "B24 프사 수정 옵션"
        public static let deleteProfileImgBtnTapped = "B25 프사 삭제 옵션"
        public static let completeProfileUpdateBtnTapped = "B26 프로필 수정 완료"
        
        public static let createNewWineBtnTapped = "B27 보유와인 생성"
        public static let updatemyWineBtnTapped = "B28 보유와인 수정"
        
        public static let instaBtnTapped = "B29 인스타그램 바로가기"
        
        public static let logoutBtnTapped = "B30 로그아웃"
        public static let quitBtnTapped = "B31 탈퇴하기"
        
        public static let alertCancelBtnTapped = "B32 얼럿 취소"
        public static let alertAcceptBtnTapped = "B33 얼럿 확인"
        
        public static let tnRateBtnTapped = "B34 별점 선택"
        
    }
    
    public struct NetworkEvent {
        private init() { }
        
        public static let settingMenuCellTapped = "S1 세팅 메뉴 선택"
        
        public static let logoutBtnTapped = "S2 로그아웃 버튼 클릭"
        public static let quitBtnTapped = "S2 탈퇴하기 버튼 클릭"
        public static let editProfileBtnTapped = "S2 프로필 수정 버튼 클릭"
        
        
    }
}
