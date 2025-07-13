// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import DesignSystem

public enum DividerFactory {
    public static func make(color: UIColor = AppColor.gray05) -> UIView {
        return UIView().then {
            $0.backgroundColor = color
        }
    }
}
