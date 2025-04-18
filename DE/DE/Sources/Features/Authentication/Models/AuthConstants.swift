// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public struct AuthConstants {
}

/// 온보딩 페이지 관련 데이터
public enum OnboardingSlide: CaseIterable {
    case onboarding1
    case onboarding2
    case onboarding3
}

extension OnboardingSlide {
    
    var imageName: String {
        switch self {
        case .onboarding1: return "onboarding1"
        case .onboarding2: return "onboarding2"
        case .onboarding3: return "onboarding3"
        }
    }
    
    var title: String {
        switch self {
        case .onboarding1: return "쉽게 배우는 와인 지식"
        case .onboarding2: return "함께 즐기는 와인"
        case .onboarding3: return "나만의 테이스팅 노트"
        }
    }
    
    var description: String {
        switch self {
        case .onboarding1: return "드링키지, 와인의 진입장벽을 낮추다."
        case .onboarding2: return "더 즐거운 시간을 공유해 보세요."
        case .onboarding3: return "다양한 테이스팅 노트를 기록하며\n나의 취향에 대해 알아 보세요."
        }
    }
}
