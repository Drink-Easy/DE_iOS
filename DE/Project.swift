import ProjectDescription

//let swiftLintScript = TargetScript.pre(
//    script: """
//    export PATH="$PATH:/opt/homebrew/bin"
//    if which swiftlint >/dev/null; then
//        swiftlint
//    else
//        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
//    fi
//    """,
//    name: "SwiftLint",
//    basedOnDependencyAnalysis: false
//)

let bundleId = "io"
let bundleMid = "DRINKIG"


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
                    "UILaunchStoryboardName": "",
//                    // 런치 스크린
//                    "UILaunchScreen" : [
//                        "UIColorName" : "LaunchScreenBGColor",
//                        "UIImageName" : "LaunchLogo",
//                        "UIImageRespectsSafeAreaInsets" : true
//                    ],
                    // 카카오 로그인 설정
                    "KAKAO_NATIVE_APP_KEY" : "180ebe6367eb8ee6eafe439aa551744a",
                    "LSApplicationQueriesSchemes" : ["kakaokompassauth" , "kakaolink", "kakaoplus"],
                    "CFBundleURLTypes" : [
                        [
                            "CFBundleTypeRole" : "Editor",
                            "CFBundleURLName" : "kakaologin",
                            "CFBundleURLSchemes" : ["kakao180ebe6367eb8ee6eafe439aa551744a"]
                        ],
                    ],
                    // 다른 설정은 여기에다가 추가
                ]
            ),
            sources: ["DE/Sources/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [ ],
            dependencies: [
                //                .target(name: "CoreModule"),
                //                .target(name: "Network"),
                .target(name: "Authentication"),
                
                    .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK")
                //                .target(name: "Core"),
                //                .target(name: "Network"),
                //                .target(name: "Authentication"),
                //
                //                // 뷰 관련
                //                .external(name: "SnapKit"),
                //                .external(name: "PinLayout"),
                //                .external(name: "FlexLayout"),
                //                .external(name: "KeychainSwift"),
                //
                //                // 컴포넌트 기능
                //                .external(name: "SDWebImage"),
                //                .external(name: "SwiftyToaster"),
                //                .external(name: "Then"),
                //                .external(name: "Cosmos"),
                
                // 카카오
                //                .external(name: "KakaoSDK"),
                //                .external(name: "KakaoSDKAuth"),
                //                .external(name: "KakaoSDKCert"),
                //                .external(name: "KakaoSDKCertCore"),
                //                .external(name: "KakaoSDKCommon")
            ]
        ),
        .target(
            name: "JoinApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleId).\(bundleMid).drinkig",
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
                    "UILaunchStoryboardName": "",
                    // 런치 스크린
                    //                    "UILaunchScreen" : [
                    //                        "UIColorName" : "LaunchScreenBGColor",
                    //                        "UIImageName" : "LaunchLogo",
                    //                        "UIImageRespectsSafeAreaInsets" : true
                    //                    ],
                    // 카카오 로그인 설정
                    "KAKAO_NATIVE_APP_KEY" : "180ebe6367eb8ee6eafe439aa551744a",
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
            sources: ["DE/Sources/App/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [  ],
            dependencies: [
                //                .target(name: "CoreModule"),
                //                .target(name: "Network"),
                .target(name: "Authentication"),
                
                .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK")
            ]
        ),
        .target(
            name: "TastingNoteApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleId).\(bundleMid).TastingNoteApp",
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
                    "UILaunchStoryboardName": "",
                    // 카카오 로그인 설정
                    "KAKAO_NATIVE_APP_KEY" : "180ebe6367eb8ee6eafe439aa551744a",
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
            sources: ["DE/Sources/App/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [  ],
            dependencies: [
                .target(name: "TastingNote"),
                
                .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK"),
                .external(name: "AMPopTip")
            ]
        ),
        .target(
            name: "HomeApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleId).\(bundleMid).HomeApp",
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
                    "KAKAO_NATIVE_APP_KEY" : "180ebe6367eb8ee6eafe439aa551744a",
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
            sources: ["DE/Sources/App/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [  ],
            dependencies: [
                .target(name: "HomeModule"),
                
                .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK")
            ]
        ),
        .target(
            name: "SearchApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleId).\(bundleMid).SearchApp",
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
                    "KAKAO_NATIVE_APP_KEY" : "180ebe6367eb8ee6eafe439aa551744a",
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
            sources: ["DE/Sources/App/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [  ],
            dependencies: [
                .target(name: "SearchModule"),
                
                .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK")
            ]
        ),
        // module
        .target(
            name: "CoreModule",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).CoreModule",
            sources: ["DE/Sources/Core/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "PinLayout"),
                .external(name: "FlexLayout"),
                .external(name: "SDWebImage"),
                .external(name: "SwiftyToaster"),
                .external(name: "Then"),
                .external(name: "Cosmos"),
                .external(name: "KakaoSDK")
            ]
        ),
        .target(
            name: "Network",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).Network",
            sources: ["DE/Sources/Network/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "CoreModule"),
                .external(name: "Moya")
            ]
        ),
        .target(
            name: "Authentication",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).Authentication",
            sources: ["DE/Sources/Features/Authentication/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "Network"),
                .target(name: "HomeModule"),
                
            ]
        ),
        .target(
            name: "TastingNote",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).TastingNote",
            sources: ["DE/Sources/Features/TastingNote/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "Network"),
                .external(name: "AMPopTip")
            ]
        ),
        .target(
            name: "HomeModule",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).HomeModule",
            sources: ["DE/Sources/Features/Home/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "SearchModule"),
                .target(name: "TastingNote"),
                .target(name: "CommunityModule")
            ]
        ),
        .target(
            name: "SearchModule",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).SearchModule",
            sources: ["DE/Sources/Features/Search/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "Network")
            ]
        ),
        .target(
            name: "CommunityModule",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).CommunityModule",
            sources: ["DE/Sources/Features/Community/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "Network")
            ]
        ),
        // Tests
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
