// Copyright © 2024 DRINKIG. All rights reserved

import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    //싱글톤 인스턴스
    static let shared = LocationManager()
    private var locationManager = CLLocationManager()
    private var completion: ((String?) -> Void)?
    var currentAddress: String?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // 위치 요청 메서드
    func requestLocationPermission(completion: @escaping (String?) -> Void) {
        self.completion = completion
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
        @unknown default:
            break
        }
    }

    // 권한 변경 감지
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            showLocationDeniedAlert()
        }
    }
    
    // 권한 거부시 alert창 띄우기
    private func showLocationDeniedAlert() {
        guard let topVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
                return
            }

        let alert = UIAlertController(
            title: "위치 서비스 비활성화",
            message: "위치 권한을 허용하려면 설정에서 활성화해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        DispatchQueue.main.async {
            topVC.present(alert, animated: true)
        }
    }

    // 위치 업데이트 처리
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        reverseGeocode(location: location) { [weak self] address in
            self?.completion?(address)
        }
        locationManager.stopUpdatingLocation()
    }
    
    // 주소 변환
    private func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            self.currentAddress = [placemark.locality, placemark.subLocality].compactMap { $0 }.joined(separator: " ")
            completion(self.currentAddress)
        }
    }
}
