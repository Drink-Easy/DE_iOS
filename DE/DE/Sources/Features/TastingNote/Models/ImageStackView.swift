// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

struct ImageStackView {
    let images = [("RedImage", "레드"), ("WhiteImage", "화이트"), ("SparklingImage", "스파클링"), ("RoseImage", "로제"), ("ETCImage", "기타")]

}

extension UIImageView {
    func loadImage(from url: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        guard let imageURL = URL(string: url) else { return }

        let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Image loading error: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
