// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public enum ServerErrorCode: String {
    case missingRequestPart = "MISSING_REQUEST_PART" // 올바른 입력인지 확인해주세요. (필수 요청 데이터 누락)
    case invalidContentType = "INVALID_CONTENT_TYPE" // 올바른 이미지가 아닙니다.
    case argumentError = "ARGUMENT_ERROR"
    case validationError = "VALIDATION_ERROR"
    // 이 위에 4개는 상세 메세지가 따로 오는 것 같기도?

    case wineNotFound = "WINE4001" // 와인이 없습니다.
    case wineUploadFailed = "WINE4002" // 와인 이미지 업로드에 실패했습니다.

    case noteNotFound = "NOTE4001" // 테이스팅 노트가 없습니다.
    case noteUnauthorized = "NOTE4002" // 본인의 노트가 아닙니다.
    case noteInvalidSort = "NOTE4003" // 올바른 와인 종류가 아닙니다.

    case memberNotFound = "MEMBER4001"
    case loginFailed = "MEMBER4002"
    case sessionUnauthorized = "MEMBER4003"
    case authRequestBodyNotFound = "MEMBER4004"
    case usernameNotFound = "MEMBER4005"
    case emailNotFound = "MEMBER4006"
    case passwordNotFound = "MEMBER4007"
    case passwordNotMatch = "MEMBER4008"
    case passwordNotInvalid = "MEMBER4009"
    case memberAlreadyExist = "MEMBER4010"
    case memberforbidden = "MEMBER4011"
    case memberproviderNotFound = "MEMBER4012"
    case roleNotFound = "MEMBER4013"
    case profileImageNotFound = "MEMBER4014"
    
    case accessTokenExpired = "ACCESS_TOKEN4001" // 인증이 만료되었습니다. 다시 로그인해주세요.
    case accessTokenInvalid = "ACCESS_TOKEN4002"
    case refreshTokenExpired = "REFRESH_TOKEN4001"

    case appleAuthFailed = "APPLE4001"
    case appleAuthInvalid = "APPLE4002"

    case wishlistNotFound = "WINE_WISHLIST4001"
    case wishlistUnauthorized = "WINE_WISHLIST4002"
    case wishlistDuplicate = "WINE_WISHLIST4003"

    case myWineNotFound = "MY_WINE4001"
    case myWineUnauthorized = "MY_WINE4002"

    case fileUploadFailed = "FILE_UPLOAD5001"
    case fileDeleteFailed = "FILE_UPLOAD5002"

    case noticeNotFound = "NOTICE4001"
    case bannerNotFound = "BANNER4001"
    
    case unknown // ❗ 예외 처리용 (서버에서 정의되지 않은 코드)
}

/// ✅ 서버 에러 코드 → 사용자 메시지 변환
extension ServerErrorCode {
    var errorMessage: String { // 사용자에게 보여줄 에러메세지 -> 안내 멘트 수정해야할 듯
        switch self {
        case .missingRequestPart: return "필수 입력값이 누락되었습니다."
        case .invalidContentType: return "올바른 형식의 파일을 업로드해주세요."
        case .argumentError, .validationError: return "입력값을 확인해주세요."

        case .wineNotFound: return "해당 와인을 찾을 수 없습니다."
        case .wineUploadFailed: return "와인 이미지 업로드에 실패했습니다."

        case .noteNotFound: return "테이스팅 노트를 찾을 수 없습니다."
        case .noteUnauthorized: return "본인의 노트만 수정할 수 있습니다."
        case .noteInvalidSort: return "올바른 와인 종류가 아닙니다."

        case .accessTokenExpired, .accessTokenInvalid, .refreshTokenExpired:
            return "인증이 만료되었습니다. 다시 로그인해주세요."

        case .appleAuthFailed, .appleAuthInvalid: return "애플 로그인에 문제가 발생했습니다."

        case .wishlistNotFound: return "위시리스트를 찾을 수 없습니다."
        case .wishlistUnauthorized: return "권한이 없는 위시리스트입니다."
        case .wishlistDuplicate: return "이미 존재하는 위시리스트입니다."

        case .myWineNotFound: return "보유 와인을 찾을 수 없습니다."
        case .myWineUnauthorized: return "권한이 없는 보유 와인입니다."

        case .fileUploadFailed: return "파일 업로드에 실패했습니다."
        case .fileDeleteFailed: return "파일 삭제에 실패했습니다."

        case .noticeNotFound: return "존재하지 않는 공지사항입니다."
        case .bannerNotFound: return "존재하지 않는 광고입니다."

        case .unknown: return "알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요."
        case .memberNotFound:
            return "사용자 인증 방식에 문제가 있습니다."
        case .loginFailed:
            return "로그인 실패1"
        case .sessionUnauthorized:
            return "로그인 실패2"
        case .authRequestBodyNotFound:
            return "로그인 실패3"
        case .usernameNotFound:
            return "로그인 실패4"
        case .emailNotFound:
            return "로그인 실패5"
        case .passwordNotFound:
            return "로그인 실패6"
        case .passwordNotMatch:
            return "로그인 실패7"
        case .passwordNotInvalid:
            return "로그인 실패8"
        case .memberAlreadyExist:
            return "로그인 실패9"
        case .memberforbidden:
            return "로그인 실패10"
        case .memberproviderNotFound:
            return "로그인 실패11"
        case .roleNotFound:
            return "로그인 실패12"
        case .profileImageNotFound:
            return "로그인 실패13"
        }
    }
}
