// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: ["Moya" : .framework,
                       "SnapKit": .framework,
                       "PinLayout": .framework,
                       "FlexLayout": .framework,
                       "KeychainSwift" : .framework,
                       
                       "KakaoSDK": .staticLibrary,
//                       "KakaoSDKAuth": .staticLibrary,
//                       "KakaoSDKCert": .staticLibrary,
//                       "KakaoSDKCertCore": .staticLibrary,
//                       "KakaoSDKCommon": .staticLibrary,
                       
                       "SDWebImage" : .framework,
                       "SwiftyToaster" : .framework,
                       "Then" : .framework,
                       "Cosmos" : .framework,
                       "AMPopTip" : .framework
                      ]
    )
#endif

let package = Package(
    name: "DE",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.5"),
        .package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.0.10"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.23.0"),
        
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
        .package(url: "https://github.com/noeyiz/SwiftyToaster.git", from: "1.0.2"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "25.0.1"),
        .package(url: "https://github.com/andreamazz/AMPopTip", from: "4.12.0"),
        .package(url: "https://github.com/heestand-xyz/PolyKit.git", from: "2.0.0")
    ]
)
