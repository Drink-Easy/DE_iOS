// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class TastingNoteList {
    @Relationship public var noteList : [TastingNote]?
    @Relationship var user: UserData?
    
    public init(noteList: [TastingNote]? = [], user: UserData? = nil) {
        self.noteList = noteList
        self.user = user
    }
}

@Model
public class TastingNote {
    @Attribute(.unique) public var noteId : Int
    @Attribute public var wineName : String
    @Attribute public var imageURL : String
    @Attribute public var sort : String
    
    
    public init(noteId: Int,
         wineName: String,
         imageURL: String,
         sort: String
    ) {
        self.noteId = noteId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
    }
}
