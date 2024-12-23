//
//  WhatsURNameViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import UIKit
import Moya
import CoreLocation

class WhatsURNameViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    let nextButton = UIButton(type: .system)
    var locationManager = CLLocationManager()
    
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "제 이름은..."
        l.textColor = .black
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(rawValue: 700))
        
        return l
    }()
    
    private let nameTextField: UITextField = {
        let t = UITextField()
        t.layer.cornerRadius = 16
        t.layer.masksToBounds = true
        t.backgroundColor = UIColor(hex: "E2E2E2")
        t.placeholder = "입력..."
        t.returnKeyType = .done
        t.clearButtonMode = .always
        t.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        t.leftViewMode = .always
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        
        nameTextField.delegate = self
        
        // nameTextField의 값이 변경될 때 updateNextButtonState를 호출하도록 설정
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // 초기 상태 업데이트
        updateNextButtonState()
        
        // Location
        setupLocationManager()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    private func setupUI() {
        configureNextButton()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
//            make.width.equalTo(338)
//            make.height.equalTo(44)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.height.equalTo(60)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.equalTo(60)
        }
    }
    
    private func configureNextButton() {
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        
        nextButton.setImage(UIImage(named: "icon_next"), for: .normal)
        nextButton.imageView?.contentMode = .center
        nextButton.tintColor = .white
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: 0)
        
        nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
        nextButton.layer.cornerRadius = 16
        nextButton.layer.borderWidth = 0
    }
    
    private func updateNextButtonState() {
        if let name = nameTextField.text {
            if name.isEmpty { // 이름 입력 안된 경우
                nextButton.isEnabled = false
                nextButton.backgroundColor = UIColor(hex: "#E2E2E2")
                nextButton.removeTarget(nil, action: nil, for: .allEvents)
            } else {
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.tintColor = .white
                nextButton.isEnabled = true
                nextButton.backgroundColor = UIColor(hex: "FA735B")
                nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
                
                // 이름 정보 전달
                SelectionManager.shared.setName(answer: name)
            }
        }
    }
    
    @objc private func nextButtonTapped() {
        let firstTasteTestViewController = FirstTasteTestViewController()
        navigationController?.pushViewController(firstTasteTestViewController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.nameTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    //MARK: - Location parts
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 서비스가 제한 또는 거부되었습니다.")
            self.locationManager.stopUpdatingLocation()
        case .notDetermined:
            print("위치 권한이 아직 결정되지 않았습니다.")
            self.locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("알 수 없는 권한 상태입니다.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 위치 정보를 기반으로 주소를 가져옴
        reverseGeocode(location: location)
        
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("역지오코딩 실패: \(error)")
                return
            }
            if let placemark = placemarks?.first {
                var address = ""
                
                if let administrativeArea = placemark.administrativeArea {
                    address += administrativeArea
                }
                
                if let locality = placemark.locality {
                    address += " \(locality)"
                }
                
                if let subLocality = placemark.subLocality {
                    address += " \(subLocality)"
                }
                
                if let thoroughfare = placemark.thoroughfare {
                    address += " \(thoroughfare)"
                }
                
                SelectionManager.shared.userAddr = address
            }
        }
    }
}

