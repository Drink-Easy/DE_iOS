// Copyright © 2024 DRINKIG. All rights reserved

import CoreModule
import UIKit
import Moya

public enum MemberEndpoint {
    // 마이페이지
    case getMemberInfo
    case patchMemeberPersonalInfo(image: UIImage, imageName: String, body : MemberUpdateRequest)
    case checkNickname(nickname: String)
    case deleteMember
    
    // 취향찾기
    case patchMemberInfo(image: UIImage, imageName: String, body : MemberRequestDTO)
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
        case .patchMemberInfo(let image, let fileName, let body):
            var multipartData: [MultipartFormData] = []
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let fileFormData = MultipartFormData(
                    provider: .data(imageData),
                    name: "multipartFile",
                    fileName: fileName,
                    mimeType: "image/jpeg"
                )
                multipartData.append(fileFormData)
            }
            
            if let jsonData = try? JSONEncoder().encode(body) {
                let jsonFormData = MultipartFormData(provider: .data(jsonData), name: "memberRequest")
                multipartData.append(jsonFormData)
            }

            return .uploadMultipart(multipartData)
        case .patchMemeberPersonalInfo(let fileData, let fileName, let body) :
            var multipartData: [MultipartFormData] = []
            if let imageData = fileData.jpegData(compressionQuality: 0.5) {
                let fileFormData = MultipartFormData(
                    provider: .data(imageData),
                    name: "multipartFile",
                    fileName: fileName,
                    mimeType: "multipart/form-data"
                )
                multipartData.append(fileFormData)
            }
            
            if let jsonData = try? JSONEncoder().encode(body) {
                let jsonFormData = MultipartFormData(
                    provider: .data(jsonData),
                    name: "memberUpdateRequest"
                )
                multipartData.append(jsonFormData)
            }

            return .uploadMultipart(multipartData)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .patchMemeberPersonalInfo, .patchMemberInfo :
            return [
                "Content-type": "multipart/octet-stream",
                "Custom-Image-type": "multipart/form-data",
//                "Custom-Image-type": "image/jpeg",
                "Custom-Json-type": "application/json"
            ]
        default :
            return ["Content-Type": "application/json"]
        }
    }

}
