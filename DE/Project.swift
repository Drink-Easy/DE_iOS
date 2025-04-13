import ProjectDescription
import Foundation

let bundleId = "io"
let bundleMid = "DRINKIG"
let releaseBundleFin = "drinkig"
let minimunTarget = "17.0"
let projectName = "DE"
let releaseTargetName = "DRINKIG"

// 버전 여기서 고치기
let major = 1
let minor = 0
let patch = 5


//let crashlyticsScript = TargetScript.post(
//    script: """
//    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
//    "${ROOT_DIR}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
//    """,
//    name: "Firebase Crashlytics",
//    inputPaths: [
//        "$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)/Contents/Resources/DWARF/$(TARGET_NAME)",
//        "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
//    ], basedOnDependencyAnalysis: true
//)

let project = Project(
    name: "\(projectName)",
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": ["-ObjC"],
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
        ],
        configurations: [
            .debug(name: "Debug", settings: [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym" // Debug 설정
            ]),
            .release(name: "Release", settings: [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym" // Release 설정
            ])
        ]
    ),
    targets: [
        .target(
            name: "\(releaseTargetName)",
            destinations: .init([.iPhone]),
            product: .app,
            bundleId: "\(bundleId).\(bundleMid).\(releaseBundleFin)",
            deploymentTargets: .iOS(minimunTarget),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString" : "\(major).\(minor).\(patch)",
                    "CFBundleVersion" : "1",
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
                    "NSUserTrackingUsageDescription" : "드링키지에서 사용자 맞춤 정보 제공 및 서비스 개선을 위해 데이터를 사용하려고 합니다.",
                    "NSLocationAlwaysAndWhenInUseUsageDescription" : "드링키지 커뮤니티 사용을 위한 위치 권한을 항상 혹은 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationWhenInUseUsageDescription" : "드링키지 커뮤니티 사용을 위한 위치 권한을 앱 활성 시에만 허용하시겠습니까?",
                    "NSLocationAlwaysUsageDescription" : "드링키지 커뮤니티 사용을 위한 위치 권한을 항상 허용하시겠습니까?",
                    "NSCameraUsageDescription" : "사용자 프로필 이미지 설정을 위한 카메라 사용 권한을 허용하시겠습니까?",
                    "NSPhotoLibraryUsageDescription" : "사용자 프로필 이미지 설정을 위한 갤러리 접근 권한을 허용하시겠습니까?",
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
                            "CFBundleURLSchemes" : ["kakao180ebe6367eb8ee6eafe439aa551744a"]
                        ],
                    ],
                    "ITSAppUsesNonExemptEncryption" : false,
                    // 다른 설정은 여기에다가 추가
                ]
            ),
            sources: ["DE/Sources/App/**"],
            resources: ["DE/Resources/**"],
            entitlements: "DE/DE.entitlements",
            scripts: [
                .post(
                    script: """
                    ROOT_DIR=${TUIST_ROOT_DIR:-$(pwd)}
                    "${ROOT_DIR}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
                    """,
                    name: "Firebase Crashlytics",
                    inputPaths: [
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
                        "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
                        "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
                    ], basedOnDependencyAnalysis: true
                )
            ],
            dependencies: [
                .target(name: "Features"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseRemoteConfig"),
                .external(name: "FirebaseAnalyticsWithoutAdIdSupport"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "KeychainSwift"),
                .external(name: "KakaoSDK")
            ],
            launchArguments: [.launchArgument(name: "-FIRDebugEnabled", isEnabled: true)]
        ),
        
        // module
        .target(
            name: "CoreModule",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).CoreModule",
            deploymentTargets: .iOS(minimunTarget),
            sources: ["DE/Sources/Core/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "NVActivityIndicatorView"),
                .external(name: "SDWebImage"),
                .external(name: "SwiftyToaster"),
                .external(name: "Then"),
                .external(name: "Cosmos"),
                .external(name: "KakaoSDK"),
                .target(name: "Network"),
                .external(name: "AMPopTip")
            ]
        ),
        .target(
            name: "Network",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).Network",
            deploymentTargets: .iOS(minimunTarget),
            sources: ["DE/Sources/Network/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseCrashlytics")
            ]
        ),
        .target(
            name: "Features",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).\(bundleMid).FeatureModule",
            deploymentTargets: .iOS(minimunTarget),
            sources: ["DE/Sources/Features/**"],
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "CoreModule"),
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
            resources: ["DE/Resources/**"],
            dependencies: [
                .target(name: "Network"),
            ]
        ),
    ],
    schemes: [
        .scheme(name: "\(projectName)-Release",
                buildAction: .buildAction(targets: ["\(releaseTargetName)"]),
                runAction: .runAction(
                    configuration: .release,
                    arguments: .arguments(
                        launchArguments: [.launchArgument(name: "-FIRDebugDisabled", isEnabled: true)]
                    )
                ),
                archiveAction: .archiveAction(configuration: .release),
                profileAction: .profileAction(configuration: .release),
                analyzeAction: .analyzeAction(configuration: .release)
               ),
        .scheme(name: "\(projectName)-Debug",
                buildAction: .buildAction(targets: ["\(releaseTargetName)"]),
                runAction: .runAction(
                    configuration: .debug,
                    arguments: .arguments(
                        launchArguments: [.launchArgument(name: "-FIRDebugDisabled", isEnabled: true)]
                    )
                ),
                archiveAction: .archiveAction(configuration: .debug),
                profileAction: .profileAction(configuration: .debug),
                analyzeAction: .analyzeAction(configuration: .debug)
               )
    ],
    fileHeaderTemplate: "Copyright © 2025 DRINKIG. All rights reserved"
)
