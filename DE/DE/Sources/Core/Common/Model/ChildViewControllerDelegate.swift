// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public protocol ChildViewControllerDelegate: AnyObject {
    func didUpdateData(_ newData: Bool)
}
