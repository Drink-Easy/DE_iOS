// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

extension Tracking {
    // 버튼, 셀, 슬라이더 등
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
        
        public static let tooltipBtnTapped = "B20_툴팁 보기"

        public static let editProfileBtnTapped = "B21_프로필 수정 시작"
        public static let changeProfileImgBtnTapped = "B22_프사 수정 옵션"
        public static let deleteProfileImgBtnTapped = "B23_프사 삭제 옵션"
        public static let completeProfileUpdateBtnTapped = "B24_프로필 수정 완료"
        
        public static let createNewWineBtnTapped = "B25_보유와인 생성"
        public static let updatemyWineBtnTapped = "B26_보유와인 수정"
        
        public static let instaBtnTapped = "B27_인스타그램 바로가기"
        
        public static let logoutBtnTapped = "B28_로그아웃"
        public static let quitBtnTapped = "B29_탈퇴하기"
        
        public static let alertCancelBtnTapped = "B30_얼럿 취소"
        public static let alertAcceptBtnTapped = "B31_얼럿 확인"
        public static let dropdownBtnTapped = "B32_드롭다운"
        
    }
}
