// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import PhotosUI

public class ImagePickerManager: NSObject, PHPickerViewControllerDelegate {
    
    // Callback to return the selected image
    public var onImagePicked: ((UIImage, String) -> Void)?
    
    // MARK: - Request Photo Library Permission
    public func requestPhotoLibraryPermission(from viewController: UIViewController) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            // ✅ 접근 권한이 있는 경우 바로 실행
            presentImagePicker(from: viewController)
            
        case .denied, .restricted:
            // ❌ 접근 불가 → 설정에서 변경하도록 유도
            showPermissionAlert(from: viewController)
            
        case .notDetermined:
            // 🔄 사용자에게 최초 권한 요청
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.presentImagePicker(from: viewController)
                    } else {
                        self?.showPermissionAlert(from: viewController)
                    }
                }
            }
            
        @unknown default:
            break
        }
    }

    // MARK: - Open PHPicker
    public func presentImagePicker(from viewController: UIViewController, selectionLimit: Int = 1) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지 필터
        configuration.selectionLimit = selectionLimit // 선택 제한
        configuration.preferredAssetRepresentationMode = .compatible
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    // MARK: - PHPicker Delegate Method
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let result = results.first else { return }

        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self else { return }
                if let image = object as? UIImage {
                    let fileName = "\(UUID().uuidString).jpeg"
                    DispatchQueue.main.async {
                        self.onImagePicked?(image, fileName)
                    }
                } else {
                    print("이미지를 불러오지 못했습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                }
            }
        } else {
            print("선택한 항목에서 이미지를 로드할 수 없습니다.")
        }
    }
    
    // MARK: - Alert for Permission
    private func showPermissionAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "사진을 선택하려면 설정에서 접근 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
