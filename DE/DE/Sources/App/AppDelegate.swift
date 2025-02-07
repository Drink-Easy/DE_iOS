// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseRemoteConfig
import Firebase
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let kakaoAPIkey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: "\(kakaoAPIkey)")
        }
        FirebaseApp.configure()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // remote config를 가져올 수 없을때 사용
        let defaultValue = ["isNeedUpdate": false]
        remoteConfig.setDefaults(defaultValue as [String : NSObject])
        
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { (changed, error) in
                    print(changed)
                    let isNeedUpdate = remoteConfig["isNeedUpdate"].boolValue
                    UserDefaults.standard.set(isNeedUpdate, forKey: "isNeedUpdate")
                    UserDefaults.standard.synchronize()
                    
                    let jsonString = remoteConfig["jsonTest"].stringValue
                    let jsonData = jsonString.data(using: .utf8)!
                    print(jsonData)
                    // ✅ JSON 디코딩
                    do {
                        let data = try JSONDecoder().decode(jsontest.self, from: jsonData)
                        if data.showStopSign {
                            UserDefaults.standard.set(data.showStopSign, forKey: "showStopSign")
                            UserDefaults.standard.set("🚨 \(data.message)", forKey: "signMessage")
                            UserDefaults.standard.set("🕒 점검 시간: \(data.startDate) ~ \(data.endDate)", forKey: "signDate")
                            UserDefaults.standard.synchronize()
                        } else {
                            print("✅ 점검 중이 아닙니다.")
                            UserDefaults.standard.set(data.showStopSign, forKey: "showStopSign")
                            UserDefaults.standard.synchronize()
                        }
                    } catch {
                        fatalError("❌ JSON 디코딩 실패: \(error.localizedDescription)")
                    }
                }
            } else {
                print("⚠️ RemoteConfig Fetch 실패: \(error?.localizedDescription ?? "알 수 없는 에러")")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}

struct jsontest : Codable {
    let showStopSign : Bool
    let startDate : String
    let endDate : String
    let message : String
}
