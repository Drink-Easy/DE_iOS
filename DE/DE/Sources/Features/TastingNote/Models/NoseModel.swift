// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct NoseSectionModel {
    let sectionTitle: String
    var items: [NoseModel]
    var isExpanded: Bool
    var selectedItems: [NoseModel] = []
}

extension NoseSectionModel {
    static func sections() -> [NoseSectionModel] {
        return [
            NoseSectionModel(sectionTitle: "꽃 계열", items: NoseModel.flowers(), isExpanded: false),
            NoseSectionModel(sectionTitle: "과일 계열", items: NoseModel.fruits(), isExpanded: false),
            NoseSectionModel(sectionTitle: "채소 계열", items: NoseModel.vegetables(), isExpanded: false),
            NoseSectionModel(sectionTitle: "향신료 계열", items: NoseModel.spices(), isExpanded: false),
            NoseSectionModel(sectionTitle: "화학 계열", items: NoseModel.chems(), isExpanded: false),
            NoseSectionModel(sectionTitle: "동물 계열", items: NoseModel.animals(), isExpanded: false),
            NoseSectionModel(sectionTitle: "탄 내 계열", items: NoseModel.burns(), isExpanded: false)
        ]
    }
}

struct NoseModel: Codable, Equatable {
    let type: String
}

extension NoseModel {
    static func flowers() -> [NoseModel] {
        return [
            NoseModel(type: "장미"),
            NoseModel(type: "말린 꽃"),
            NoseModel(type: "아카시아"),
            NoseModel(type: "오렌지 꽃"),
            NoseModel(type: "금작화"),
            NoseModel(type: "붓꽃"),
            NoseModel(type: "작약"),
            NoseModel(type: "시든 장미"),
            NoseModel(type: "제비 꽃"),
            NoseModel(type: "소나무"),
        ]
    }
    
    static func fruits() -> [NoseModel] {
        return [
            NoseModel(type: "체리"),
            NoseModel(type: "딸기"),
            NoseModel(type: "산딸기"),
            NoseModel(type: "올리브"),
            NoseModel(type: "살구"),
            NoseModel(type: "레몬"),
            NoseModel(type: "오렌지"),
            NoseModel(type: "자몽"),
            NoseModel(type: "파인애플"),
            NoseModel(type: "바나나"),
            NoseModel(type: "무화과"),
            NoseModel(type: "절인 과일"),
            NoseModel(type: "망고"),
            NoseModel(type: "리치"),
            NoseModel(type: "파파야"),
            NoseModel(type: "아몬드"),
            NoseModel(type: "헤이즐넛"),
            NoseModel(type: "호두"),
            NoseModel(type: "메론"),
            NoseModel(type: "복숭아"),
            NoseModel(type: "배"),
            NoseModel(type: "사과"),
            NoseModel(type: "자두"),
            NoseModel(type: "꿀"),
        ]
    }
    
    static func vegetables() -> [NoseModel] {
        return [
            NoseModel(type: "싹"),
            NoseModel(type: "버섯"),
            NoseModel(type: "트러플"),
            NoseModel(type: "나무"),
            NoseModel(type: "파프리카"),
            NoseModel(type: "토마토"),
            NoseModel(type: "펜넬"),
            NoseModel(type: "건초"),
            NoseModel(type: "허브"),
            NoseModel(type: "민트"),
            NoseModel(type: "짚"),
        ]
    }
    
    static func spices() -> [NoseModel] {
        return [
            NoseModel(type: "월계수"),
            NoseModel(type: "후추"),
            NoseModel(type: "타임"),
            NoseModel(type: "시나몬"),
            NoseModel(type: "바닐라"),
            NoseModel(type: "감초"),
            NoseModel(type: "소금"),
        ]
    }
    
    static func chems() -> [NoseModel] {
        return [
            NoseModel(type: "아세톤"),
            NoseModel(type: "바나나"),
            NoseModel(type: "효모"),
            NoseModel(type: "황"),
            NoseModel(type: "매니큐어"),
            NoseModel(type: "버터"),
            NoseModel(type: "브리오슈"),
            NoseModel(type: "크림"),
            NoseModel(type: "발효제"),
            NoseModel(type: "우유"),
            NoseModel(type: "빵"),
        ]
    }
    
    static func animals() -> [NoseModel] {
        return [
            NoseModel(type: "가죽"),
            NoseModel(type: "모피"),
            NoseModel(type: "육즙"),
        ]
    }
    
    static func burns() -> [NoseModel] {
        return [
            NoseModel(type: "카카오"),
            NoseModel(type: "시가"),
            NoseModel(type: "훈연"),
            NoseModel(type: "담배"),
            NoseModel(type: "토스트한 빵"),
            NoseModel(type: "커피"),
            NoseModel(type: "차"),
        ]
    }
}
