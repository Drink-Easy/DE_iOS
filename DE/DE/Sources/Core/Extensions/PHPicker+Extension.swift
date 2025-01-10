// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import PhotosUI

public class ImagePickerManager: NSObject, PHPickerViewControllerDelegate {
    
    // Callback to return the selected image
    public var onImagePicked: ((UIImage, String) -> Void)?

    // Open PHPicker
    public func presentImagePicker(from viewController: UIViewController, selectionLimit: Int = 1) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지 필터
        configuration.selectionLimit = selectionLimit // 선택 제한
        configuration.preferredAssetRepresentationMode = .compatible
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    // PHPicker Delegate Method
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
}
