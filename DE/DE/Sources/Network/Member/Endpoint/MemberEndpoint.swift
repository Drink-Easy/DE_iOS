// Copyright © 2024 DRINKIG. All rights reserved

import CoreModule
import Foundation
import Moya

public enum MemberEndpoint {
    // 마이페이지
    case getMemberInfo
    case patchMemeberPersonalInfo(fileData: Data, fileName: String, body : MemberUpdateRequest)
    case checkNickname(nickname: String)
    case deleteMember
    
    // 취향찾기
    case patchMemberInfo(fileData: Data, fileName: String, body : MemberRequestDTO)
}

extension MemberEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.memberURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .patchMemberInfo :
            return ""
        case .checkNickname(let name) :
            return "/\(name)"
        case .deleteMember :
            return "/delete"
        default :
            return "/info"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname :
            return .post
        case .getMemberInfo :
            return .get
        case .patchMemberInfo, .patchMemeberPersonalInfo :
            return .patch
        case .deleteMember :
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .getMemberInfo:
            return .requestPlain
        case .deleteMember:
            return .requestPlain
        case .patchMemberInfo(let fileData, let fileName, let body):
            var multipartData: [MultipartFormData] = []
            let fileFormData = MultipartFormData(
                provider: .data(fileData),
                name: "multipartFile",
                fileName: fileName,
                mimeType: "application/json"
            )
            multipartData.append(fileFormData)
            
            if let jsonData = try? JSONEncoder().encode(body) {
                let jsonFormData = MultipartFormData(
                    provider: .data(jsonData),
                    name: "memberRequest", // 서버가 요구하는 필드 이름
                    fileName: "memberRequest.json",
                    mimeType: "application/json"
                )
                multipartData.append(jsonFormData)
            }

            return .uploadMultipart(multipartData)
        case .patchMemeberPersonalInfo(let fileData, let fileName, let body) :
            var multipartData: [MultipartFormData] = []
            let fileFormData = MultipartFormData(
                provider: .data(fileData),
                name: "multipartFile",
                fileName: fileName,
                mimeType: "application/json"
            )
            multipartData.append(fileFormData)
            
            if let jsonData = try? JSONEncoder().encode(body) {
                let jsonFormData = MultipartFormData(
                    provider: .data(jsonData),
                    name: "memberRequest", // 서버가 요구하는 필드 이름
                    fileName: "memberRequest.json",
                    mimeType: "application/json"
                )
                multipartData.append(jsonFormData)
            }

            return .uploadMultipart(multipartData)
        }
    }
    
    public var headers: [String : String]? {
        return [ "Content-type": "application/json" ]
    }

}
