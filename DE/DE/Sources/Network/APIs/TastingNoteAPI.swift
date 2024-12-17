//
//  BasicAPI.swift
//  Drink-EG
//
//  Created by 김도연 on 8/11/24.
//

import Foundation
import Moya

// JWT 토큰을 받을 수 있도록 BasicAPI 정의
/// 기능 하나 당 API 1개씩 만들기
/// - API 명세서 기준으로 1 명세서 당 1 API enum 정의하기
/// - 변경을 한 번 더 해보자.

enum TastingNoteAPI {
    case getAllNotes
    case getWineName(wineName: String)
    case getNoteID(noteId: Int)
    case postNewNote(wineId: Int, color: String, sugarContent: Int, acidity: Int, tannin: Int, body: Int, alcohol: Int, scentAroma: [String], scentTaste: [String], scentFinish: [String], satisfaction: Int, memo: String)
    case patchNote(wineId: Int, color: String, sugarContent: Int, acidity: Int, tannin: Int, body: Int, alcohol: Int, scentAroma: [String], scentTaste: [String], scentFinish: [String], satisfaction: Int, review: String)
    case deleteNote(noteId: Int)
}

extension TastingNoteAPI: TargetType {
    var baseURL: URL {
        /// 기본 URL 작성
        return URL(string: "https://drinkeg.com/")!
      
    }
    
    var path: String {
        /// 기본 URL + path 로 URL 구성
        switch self {
            /// 동일한 path는 한 case로 처리 가능
        case .getWineName:
            return "wine"
        case .getAllNotes:
            return "tasting-note/all-note"
        case .getNoteID(let noteId):
            return "tasting-note/\(noteId)"
        case .postNewNote:
            return "tasting-note/new-note"
        case .patchNote(let wineId, _, _, _, _, _, _, _, _, _, _, _):
            return "wine-note/\(wineId)"
        case .deleteNote(let noteId):
            return "tasting-note/\(noteId)"
        }
    }
    
    var method: Moya.Method {
        /// 각 case 별로 적합한 method 배정
        switch self {
        case .getWineName, .getAllNotes, .getNoteID:
            return .get
        case .postNewNote:
            return .post
        case .patchNote:
            return .patch
        case .deleteNote:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getWineName(let wineName):
            return .requestParameters(parameters: ["searchName": wineName], encoding: URLEncoding.queryString)
        case .getAllNotes, .getNoteID:
            return .requestPlain
        case .postNewNote(let wineId, let color, let sugarContent, let acidity, let tannin, let body, let alcohol, let scentAroma, let scentTaste, let scentFinish, let satisfaction, let review):
            let parameters: [String: Any] = [
                "wineId": wineId,
                "color": color,
                "sugarContent": sugarContent,
                "acidity": acidity,
                "tannin": tannin,
                "body": body,
                "alcohol": alcohol,
                "scentAroma": scentAroma,
                "scentTaste": scentTaste,
                "scentFinish": scentFinish,
                "satisfaction": satisfaction,
                "review": review
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .patchNote(_, let color, let sugarContent, let acidity, let tannin, let body, let alcohol, let scentAroma, let scentTaste, let scentFinish, let satisfaction, let review):
            let parameters: [String: Any] = [
                "color": color,
                "sugarContent": sugarContent,
                "acidity": acidity,
                "tannin": tannin,
                "body": body,
                "alcohol": alcohol,
                "scentAroma": scentAroma,
                "scentTaste": scentTaste,
                "scentFinish": scentFinish,
                "satisfaction": satisfaction,
                "review": review
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteNote:
            return .requestPlain
        }
    }
    
    // API 호출 시, header에 token 넣어서 전달
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

