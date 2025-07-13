// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

// MARK: - Section Model
public struct Section<Item: SectionItem> {
    public var title: String
    public var isExpanded: Bool
    public var items: [Item]
    
    public init(title: String, isExpanded: Bool, items: [Item]) {
        self.title = title
        self.isExpanded = isExpanded
        self.items = items
    }
}

// MARK: - SectionItem Model
public protocol SectionItem {
    var displayText: String { get }
    var accessoryText: String? { get }
}

// 기본 String 타입을 위한 Extension
extension String: SectionItem {
    public var displayText: String { self }
    public var accessoryText: String? { nil }
}
