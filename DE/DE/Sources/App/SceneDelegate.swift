// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Features
import Network
import KakaoSDKAuth
import KakaoSDKUser

import FirebaseRemoteConfig
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 화면을 구성하는 UIWindow 인스턴스 생성
        let window = UIWindow(windowScene: windowScene)
        // 실제 첫 화면이 되는 MainViewController 인스턴스 생성
        
        let vc = SplashVC()
        
        // NavigationController을 사용할 경우, MainViewController를 rootViewController로 갖는 NavigationController을 생성해야한다.
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        // UIWindow의 시작 ViewController를 생성한 NavigationController로 지정
        window.rootViewController = navigationController
        // window 표시.
        self.window = window
        // makeKeyAndVisible() 메서드 호출
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 앱이 활성화될 때 RemoteConfig 가져오기
        //fetchRemoteConfig()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 앱이 백그라운드에서 돌아올 때도 RemoteConfig 새로고침
        //fetchRemoteConfig()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func fetchRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0  // 즉시 업데이트
        remoteConfig.configSettings = settings
        
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
                        let data = try JSONDecoder().decode(JsonTest.self, from: jsonData)
                        if data.showStopSign {
                            UserDefaults.standard.set(data.showStopSign, forKey: "showStopSign")
                            UserDefaults.standard.set(data.message, forKey: "signMessage")
                            UserDefaults.standard.set(data.stopDate, forKey: "signDate")
                            UserDefaults.standard.synchronize()
                        } else {
                            print("✅ 점검 중이 아닙니다.")
                        }
                    } catch {
                        fatalError("❌ JSON 디코딩 실패: \(error.localizedDescription)")
                    }
                }
            } else {
                print("⚠️ RemoteConfig Fetch 실패: \(error?.localizedDescription ?? "알 수 없는 에러")")
            }
        }
    }
}

struct JsonTest : Codable {
    let showStopSign : Bool
    let stopDate : String
    let message : String
}
