// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import NVActivityIndicatorView
import DesignSystem

let viewWidth: CGFloat = 40
let viewHeight: CGFloat = 40

let centerX = (Constants.superViewWidth - viewWidth) / 2
let centerY = (Constants.superViewHeight - viewHeight) / 2

public let indicator = NVActivityIndicatorView(frame: CGRect(x: centerX, y: centerY, width: viewWidth, height: viewHeight),
                                                   type: .circleStrokeSpin,
                                               color: AppColor.gray70,
                                               padding: 0)
