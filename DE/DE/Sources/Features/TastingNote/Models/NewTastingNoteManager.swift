// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class NewTastingNoteManager {
    // MARK: - Singleton
    public static let shared = NewTastingNoteManager()
    
    // MARK: - Properties
    var noteId: Int = 0
    var wineId: Int = 0
    var color: String = ""
    var tasteDate: String = ""
    var sugarContent: Int = 0
    var acidity: Int = 0
    var tannin: Int = 0
    var body: Int = 0
    var alcohol: Int = 0
    var nose: [String] = []
    var rating: Double = 0.0
    var review: String = ""
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Save Functions
    func saveWineId(_ id: Int) {
        self.wineId = id
    }
    
    func saveColor(_ color: String) {
        self.color = color
    }
    
    func saveTasteDate(_ date: String) {
        self.tasteDate = date
    }
    
    func savePalate(sugarContent: Int, acidity: Int, tannin: Int, body: Int, alcohol: Int) {
        self.sugarContent = sugarContent
        self.acidity = acidity
        self.tannin = tannin
        self.body = body
        self.alcohol = alcohol
    }
    
    func saveNose(_ values: [String]) {
        self.nose = values
    }
    
    func saveRating(_ value: Double) {
        self.rating = value
    }
    
    func saveReview(_ text: String) {
        self.review = text
    }
    
    // MARK: - Save All Data
    func saveAllData(
        noteId: Int,
        wineId: Int,
        color: String,
        tasteDate: String,
        sugarContent: Int,
        acidity: Int,
        tannin: Int,
        body: Int,
        alcohol: Int,
        nose: [String],
        rating: Double,
        review: String
    ) {
        self.noteId = noteId
        self.wineId = wineId
        self.color = color
        self.tasteDate = tasteDate
        self.sugarContent = sugarContent
        self.acidity = acidity
        self.tannin = tannin
        self.body = body
        self.alcohol = alcohol
        self.nose = nose
        self.rating = rating
        self.review = review
    }
    
    // MARK: - Fetch Functions
    func getWineId() -> Int {
        return wineId
    }
    
    func getColor() -> String {
        return color
    }
    
    func getTasteDate() -> String {
        return tasteDate
    }
    
    func getSliderValues() -> [Double] {
        return [Double(sugarContent), Double(alcohol), Double(tannin), Double(body), Double(acidity)]
    }
    
    func getNose() -> [String] {
        return nose
    }
    
    func getRating() -> Double {
        return rating
    }
    
    func getReview() -> String {
        return review
    }
}
