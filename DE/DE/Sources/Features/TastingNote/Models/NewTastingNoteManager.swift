// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class NewTastingNoteManager {
    // MARK: - Singleton
    public static let shared = NewTastingNoteManager()
    
    // MARK: - Properties
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
    
    func saveSugarContent(_ value: Int) {
        self.sugarContent = value
    }
    
    func saveAcidity(_ value: Int) {
        self.acidity = value
    }
    
    func saveTannin(_ value: Int) {
        self.tannin = value
    }
    
    func saveBody(_ value: Int) {
        self.body = value
    }
    
    func saveAlcohol(_ value: Int) {
        self.alcohol = value
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
    
    func getSugarContent() -> Int {
        return sugarContent
    }
    
    func getAcidity() -> Int {
        return acidity
    }
    
    func getTannin() -> Int {
        return tannin
    }
    
    func getBody() -> Int {
        return body
    }
    
    func getAlcohol() -> Int {
        return alcohol
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
