// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

extension Tracking {
    public struct Network {
        private init() { }
        
        //MARK: - Settings
        public static let settingMenuCellTapped = "S1_세팅 메뉴 선택"
        
        public static let logoutBtnTapped = "S2_로그아웃 버튼 클릭"
        public static let quitBtnTapped = "S2_탈퇴하기 버튼 클릭"
        public static let editProfileBtnTapped = "S2_프로필 수정 버튼 클릭"
        
        public static let startChangeProfileImgBtnTapped = "S3_프로필 이미지 수정 버튼 클릭"
        public static let changeProfileImgBtnTapped = "S3_프로필 이미지 수정 옵션 클릭"
        public static let deleteProfileImgBtnTapped = "S3_프로필 이미지 삭제 옵션 클릭"
        public static let checkDuplicateNicknameBtnTapped = "U2_S3_닉네임 중복 검사 버튼 클릭"
        public static let fetchLocationBtnTapped = "U2_S3_GPS 활성화 버튼 클릭"
        public static let completeProfileUpdateBtnTapped = "S3_프로필 수정 완료 버튼 클릭"
        
        public static let wishlistCellTapped = "S4_위시리스트 항목 선택"
        
        public static let myWineCellTapped = "S5_보유와인 항목 선택"
        public static let createNewWineBtnTapped = "S5_보유와인 생성 버튼 클릭"
        public static let updatemyWineBtnTapped = "S5_보유와인 수정 버튼 클릭"
        
    }
    
}
