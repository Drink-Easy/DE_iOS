// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

class NoseManager {
    static let shared = NoseManager()
    private init() {}
    
    /// 섹션 분류
    var scentSections = ScentSection.sections()
    
    /// 선택된 향
    var selectedScents: [Scent] {
        return scentSections.flatMap { $0.scents.filter { $0.isSelected } }
    }
    
    func toggleScentSelection(_ scentName: String) {
        for sectionIndex in 0..<scentSections.count {
            for scentIndex in 0..<scentSections[sectionIndex].scents.count {
                if scentSections[sectionIndex].scents[scentIndex].name == scentName {
                    scentSections[sectionIndex].scents[scentIndex].isSelected.toggle()
                    return
                }
            }
        }
    }
    
    public func resetAllScents() {
        for sectionIndex in 0..<scentSections.count {
            for scentIndex in 0..<scentSections[sectionIndex].scents.count {
                scentSections[sectionIndex].scents[scentIndex].isSelected = false
            }
        }
        print("🔄 모든 향 선택 해제 완료!")
    }
    
    public func applySelectedScents(from selectedScentNames: [String]) {
        resetAllScents()
        
        for sectionIndex in 0..<scentSections.count {
            for scentIndex in 0..<scentSections[sectionIndex].scents.count {
                let scent = scentSections[sectionIndex].scents[scentIndex]
                if selectedScentNames.contains(scent.name) {
                    scentSections[sectionIndex].scents[scentIndex].isSelected = true
                }
            }
        }
//        print("✅ 선택된 향 적용 완료: \(selectedScentNames)")
    }
    
    func collapseAllSections() {
        for sectionIndex in 0..<scentSections.count {
            scentSections[sectionIndex].isExpand = false
        }
    }
}

struct Scent {
    let name: String
    var isSelected: Bool
}

struct ScentSection {
    let header: String
    var isExpand: Bool
    var scents: [Scent]
}

extension Scent {
    static func flowers() -> [Scent] {
        let name = ["장미", "말린 꽃", "아카시아", "오렌지 꽃", "금작화", "붓꽃",
                    "작약", "시든 장미", "제비 꽃", "소나무"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func fruits() -> [Scent] {
        let name = ["체리", "딸기", "산딸기", "올리브", "살구", "레몬",
                    "오렌지", "자몽", "파인애플", "바나나", "무화과",
                    "절인 과일", "망고", "리치", "파파야", "아몬드",
                    "헤이즐넛", "호두", "메론", "복숭아", "배", "사과", "자두", "꿀"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func vegetables() -> [Scent] {
        let name = ["싹", "버섯", "트러플", "나무", "파프리카", "토마토",
                    "펜넬", "건초", "허브", "민트", "짚"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func spices() -> [Scent] {
        let name = ["월계수", "후추", "타임", "시나몬", "바닐라", "감초", "소금"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func chemicals() -> [Scent] {
        let name = ["아세톤", "효모", "황", "매니큐어", "버터",
                    "브리오슈", "크림", "발효제", "우유", "빵"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func animals() -> [Scent] {
        let name = ["가죽", "모피", "육즙"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
    static func burns() -> [Scent] {
        let name = ["카카오", "시가", "훈연", "담배", "토스트한 빵",
                    "커피", "차"]
        
        return name.map { Scent(name: $0, isSelected: false) }
    }
    
}

extension ScentSection {
    static func sections() -> [ScentSection] {
        return [
            ScentSection(header: "꽃", isExpand: false, scents: Scent.flowers()),
            ScentSection(header: "과일", isExpand: false, scents: Scent.fruits()),
            ScentSection(header: "채소", isExpand: false, scents: Scent.vegetables()),
            ScentSection(header: "향신료", isExpand: false, scents: Scent.spices()),
            ScentSection(header: "화학", isExpand: false, scents: Scent.chemicals()),
            ScentSection(header: "동물", isExpand: false, scents: Scent.animals()),
            ScentSection(header: "탄 내", isExpand: false, scents: Scent.burns())
        ]
    }
}

extension NoseManager {
    /// ✅ 모든 선택된 향 초기화 (선택 해제)
    func resetSelectedScents() {
        for sectionIndex in 0..<scentSections.count {
            for scentIndex in 0..<scentSections[sectionIndex].scents.count {
                scentSections[sectionIndex].scents[scentIndex].isSelected = false
            }
        }
    }
}
