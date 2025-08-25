// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct API {
    // MARK: - Endpoints
    public static var authURL: String {"\(baseURL)"}
    public static var commentURL: String { "\(baseURL)/comments" }
    public static var recommentURL: String { "\(baseURL)/recomments" }
    public static var tastingNoteURL: String { "\(baseURL)/tasting-note" }
    public static var wineClassURL: String { "\(baseURL)/wine-class" }
    public static var wineLectureURL: String { "\(baseURL)/wine-lecture" }
    public static var wineLectureCompleteURL: String { "\(baseURL)/wine-lecture-complete" }
    public static var wineURL: String { "\(baseURL)/wine" }
    public static var wishlistURL: String { "\(baseURL)/wine-wishlist" }
    public static var myWineURL: String { "\(baseURL)/my-wine" }
    public static var memberURL: String { "\(baseURL)/member" }
    public static var noticeURL: String { "\(baseURL)/notice" }
    
    // MARK: - Base URL
    /// 외부에서 접근할 필요 없으므로 private 유지
    private static var baseURL: String {
        guard let url = Bundle.main.infoDictionary?["API_BASE_URL"] as? String else {
            fatalError("Info.plist에 API_BASE_URL이 설정되지 않았습니다.")
        }
        return url
    }
}
