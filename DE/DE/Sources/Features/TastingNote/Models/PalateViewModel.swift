// Copyright © 2024 DRINKIG. All rights reserved

import SwiftUI

public class PalateViewModel: ObservableObject {
    @Published var stats: [RadarData] = [RadarData(label: "당도", value: 0.6), RadarData(label: "알코올", value: 0.6), RadarData(label: "타닌", value: 0.6), RadarData(label: "바디", value: 0.6), RadarData(label: "산도" , value: 0.6)]
    
    func loadSliderValues(from sliderValues: [String: Int]) {
        stats = [
            RadarData(label: "당도", value: Double(sliderValues["Sweetness"] ?? 60) / 100),
            RadarData(label: "알코올", value: Double(sliderValues["Alcohol"] ?? 60) / 100),
            RadarData(label: "타닌", value: Double(sliderValues["Tannin"] ?? 60) / 100),
            RadarData(label: "바디", value: Double(sliderValues["Body"] ?? 60) / 100),
            RadarData(label: "산도", value: Double(sliderValues["Acidity"] ?? 60) / 100)
        ]
    }
    
    func loadSavedValues(sweetness: Double, alcohol: Double, tannin: Double, body: Double, acidity: Double) {
        stats = [
            RadarData(label: "당도", value: sweetness / 100),
            RadarData(label: "알코올", value: alcohol / 100),
            RadarData(label: "타닌", value: tannin / 100),
            RadarData(label: "바디", value: body / 100),
            RadarData(label: "산도", value: acidity / 100)
        ]
    }
}

struct RadarData {
    let label: String
    let value: Double // 0.0 ~ 1.0
}
