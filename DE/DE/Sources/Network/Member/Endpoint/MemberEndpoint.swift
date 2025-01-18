// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Moya

public enum MemberEndpoint {
    // 마이페이지
    case getMemberInfo
    case patchMemeberPersonalInfo(body : MemberUpdateRequest)
    case checkNickname(nickname: String)
    case deleteMember
    
    case postImage(image: UIImage)
    
    // 취향찾기
    case patchMemberInfo(body : MemberRequestDTO)
}

extension MemberEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.memberURL) else {
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
        case .postImage:
            return "/profileImage"
        default :
            return "/info"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname, .postImage :
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
        case .postImage(let image):
            var multipartData: [MultipartFormData] = []
            let fileName = "\(UUID().uuidString).jpeg"
            if let imageData = image.jpegData(compressionQuality: 0.2) {
                let fileFormData = MultipartFormData(
                    provider: .data(imageData),
                    name: "profileImg",
                    fileName: fileName,
                    mimeType: "image/jpeg"
                )
                multipartData.append(fileFormData)
            }
            return .uploadMultipart(multipartData)
        case .patchMemberInfo(let body):
            return .requestJSONEncodable(body)
        case .patchMemeberPersonalInfo(let body) :
            return .requestJSONEncodable(body)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .postImage:
            return [
                "Content-type": "multipart/form-data",
            ]
        default :
            return ["Content-Type": "application/json"]
        }
    }

}
