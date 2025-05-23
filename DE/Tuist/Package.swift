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
                       "KeychainSwift" : .framework,
                       
                       "KakaoSDK": .staticLibrary,
                       
                       "SDWebImage" : .framework,
                       "SwiftyToaster" : .framework,
                       "Then" : .framework,
                       "Cosmos" : .framework,
                       "AMPopTip" : .framework,
                       "FirebaseCore" : .staticLibrary,
                       "FirebaseAnalytics" : .staticLibrary,
                       "FirebaseCrashlytics" : .staticLibrary,
                       "FirebaseAnalyticsSwift" : .staticLibrary,
                       "FirebaseAnalyticsWithoutAdIdSupport" : .staticLibrary,
                       "FirebaseMessaging" : .staticLibrary,
                       "FirebaseFirestore" : .staticLibrary,
                       "FirebaseRemoteConfig" : .staticLibrary,
                       "FirebaseAppCheck" : .staticLibrary
                      ]
    )
#endif

let package = Package(
    name: "DE",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.23.0"),
        
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.19.7"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.2.0"),
        .package(url: "https://github.com/noeyiz/SwiftyToaster.git", from: "1.0.2"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "25.0.1"),
        .package(url: "https://github.com/andreamazz/AMPopTip", from: "4.12.0"),
        .package(url: "https://github.com/heestand-xyz/PolyKit.git", from: "2.0.0"),
//        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.7.0")
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.4.0")
    ],
    targets: [
        .target(
            name: "DE",
            dependencies: [
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "GoogleUtilities", package: "firebase-ios-sdk"), // 추가
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"), // 추가
                .product(name: "FirebaseAnalyticsWithoutAdIdSupport", package: "firebase-ios-sdk"), // 추가
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"), // 추가
            ]
        ),
    ]
)
