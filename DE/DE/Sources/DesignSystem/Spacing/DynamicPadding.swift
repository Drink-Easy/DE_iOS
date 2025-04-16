// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public struct DynamicPadding {
    public static var superViewHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    public static var superViewWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var widthScaleFactor : CGFloat {
        get {
            return DynamicPadding.superViewWidth / 390
        }
    }
    
    public static func dynamicValue(_ baseValue: CGFloat) -> CGFloat {
        return baseValue * (superViewHeight / 844)
    }
    
    public static func dynamicValuebyWidth(_ baseValue: CGFloat) -> CGFloat {
        return baseValue * (superViewWidth / 390)
    }
}
