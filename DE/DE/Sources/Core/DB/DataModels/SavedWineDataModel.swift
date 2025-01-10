// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class SavedWineDataModel {
    @Attribute public var noteId: Int
    @Attribute public var wineName: String
    @Attribute public var imageURL : String
    @Attribute public var sort: String
    @Relationship public var user: UserData?
    
    public init(noteId: Int,
                wineName: String,
                imageURL: String,
                sort: String,
                user: UserData? = nil) {
        self.noteId = noteId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
        self.user = user
    }
}
