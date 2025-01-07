// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class PreviewData {
    @Attribute public var noteId : Int
    @Attribute public var wineName : String
    @Attribute public var imageURL : String
    @Attribute public var sort : String
    
    
    init(noteId: Int, wineName: String, imageURL: String, sort: String) {
        self.noteId = noteId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
    }
}

// 노트 카운터만 담은 클래스

// 노트 카운터랑 프리뷰데이터를 담은 클래스

// 
