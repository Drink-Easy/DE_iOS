// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UIImage {
    public func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
