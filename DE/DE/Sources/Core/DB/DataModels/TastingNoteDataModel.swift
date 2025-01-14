// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class TastingNoteData {
    @Attribute public var noteId : Int
    @Attribute public var wineName : String
    @Attribute public var imageURL : String
    @Attribute public var sort : String
    
    @Relationship var user: UserData?
    
    
    public init(noteId: Int,
         wineName: String,
         imageURL: String,
         sort: String,
         user: UserData?
    ) {
        self.noteId = noteId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
        self.user = user
    }
}

