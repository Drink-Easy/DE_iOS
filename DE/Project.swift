import ProjectDescription

let project = Project(
    name: "DE",
    targets: [
        .target(
            name: "DE",
            destinations: .init([.iPhone, .iPad]),
            product: .app,
            bundleId: "io.DRINKIG.DE",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIUserInterfaceStyle" : "Light", // 다크모드 제거
                    "UISupportedInterfaceOrientations" : ["UIInterfaceOrientationPortrait"], // 화면 방향 세로 고정
                    "UIApplicationSceneManifest": [ // Scene 설정
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    // 폰트 추가
                    "UIAppFonts": ["Pretendard-Black.otf",
                                   "Pretendard-Bold.otf",
                                   "Pretendard-ExtraBold.otf",
                                   "Pretendard-ExtraLight.otf",
                                   "Pretendard-Light.otf",
                                   "Pretendard-Medium.otf",
                                   "Pretendard-Regular.otf",
                                   "Pretendard-SemiBold.otf",
                                   "Pretendard-Thin.otf"
                    ],
                    // http 연결 설정
                    "NSAppTransportSecurity" : [
                        "NSAllowsArbitraryLoads" : true
                    ],
                    // 런치 스크린
                    "UILaunchScreen" : [
                        "UIColorName" : "LaunchScreenBGColor",
                        "UIImageName" : "LaunchLogo",
                        "UIImageRespectsSafeAreaInsets" : true
                    ],
                    // 카카오 로그인 설정
                    "LSApplicationQueriesSchemes" : ["kakaokompassauth" , "kakaolink", "kakaoplus"],
                    "CFBundleURLTypes" : [
                        [
                        "CFBundleTypeRole" : "Editor",
                        "CFBundleURLName" : "kakaologin",
                        "CFBundleURLSchemes" : ["kakao74177ce7b14b89614c47ac7d51464b95"]
                        ],
                    ],
                    // 다른 설정은 여기에다가 추가
                ]
            ),
            sources: ["DE/Sources/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            dependencies: [
                // 뷰 관련
                .external(name: "Moya"),
                .external(name: "SnapKit"),
                .external(name: "PinLayout"),
                .external(name: "FlexLayout"),
                .external(name: "KeychainSwift"),
                
                // 컴포넌트 기능
                .external(name: "SDWebImage"),
                .external(name: "SwiftyToaster"),
                .external(name: "Then"),
                .external(name: "Cosmos"),
                
                // 카카오
                .external(name: "KakaoSDK"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKCert"),
                .external(name: "KakaoSDKCertCore"),
                .external(name: "KakaoSDKCommon")
            ]
        ),
        .target(
            name: "DETests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DETests",
            infoPlist: .default,
            sources: ["DE/Tests/**"],
            resources: [],
            dependencies: [.target(name: "DE")]
        ),
    ],
    fileHeaderTemplate: "Copyright © 2024 DRINKIG. All rights reserved"
)
