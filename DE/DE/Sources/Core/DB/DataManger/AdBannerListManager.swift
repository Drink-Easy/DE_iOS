// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

/// 🔥 모든 유저가 공유하는 광고 배너 리스트를 관리하는 싱글톤 매니저
public final class AdBannerListManager {
    
    /// 싱글톤 인스턴스
    public static let shared = AdBannerListManager()
    
    /// SwiftData 컨테이너 초기화 (유저 데이터와 분리된 저장소)
    lazy var container: ModelContainer = {
        do {
            let storeURL = Self.storeURL()
            let configuration = ModelConfiguration(url: storeURL)
            let container = try ModelContainer(
                for: AdBannerDataModel.self, AdBannerList.self,
                configurations: configuration
            )
            print("✅ AdBannerListManager SwiftData 초기화 성공! 저장 경로: \(storeURL.path)")
            return container
        } catch {
            print("❌ AdBannerListManager SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("AdBannerListManager SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    private init() {} // 싱글톤이므로 외부에서 인스턴스 생성 방지
    
    // MARK: - Public Methods
    
    /// 🔹 광고 배너 데이터를 저장하는 메서드 (없으면 생성, 있으면 업데이트)
    /// - Parameters:
    ///   - bannerData: 저장할 배너 데이터 리스트
    ///   - expirationDate: 데이터 유효기간 설정 (기본값: 오늘)
    /// - Throws: SwiftData 저장 오류 발생 시 예외 처리
    @MainActor
    public func saveAdBannerList(bannerData: [AdBannerDataModel], expirationDate: Date = Calendar.current.startOfDay(for: Date())) throws {
        let context = container.mainContext
        
        // ✅ 기존 데이터를 가져오거나 새로 생성
        let bannerList = try fetchOrCreateBannerList(in: context)
        bannerList.wineList = bannerData
        bannerList.timestamp = expirationDate
        
        try context.save()
        print("✅ 배너 리스트 저장 완료!")
    }
    
    /// 🔹 광고 배너 데이터를 가져오는 메서드 (만료된 데이터는 자동 삭제)
    /// - Returns: 저장된 배너 데이터 리스트
    /// - Throws: `AdBannerListError.bannerListExpired` (데이터가 없거나 만료됨)
    @MainActor
    public func fetchAdBannerList() throws -> [AdBannerDataModel] {
        let context = container.mainContext
        
        // ✅ 데이터 만료 확인 후 삭제
        if try isBannerDataExpired(in: context) {
            try deleteExpiredBanners()
            throw AdBannerListError.bannerListExpired
        }
        
        return try fetchOrCreateBannerList(in: context).wineList
    }
    
    /// 🔹 만료된 광고 배너 데이터를 삭제하는 메서드
    /// - Throws: SwiftData 삭제 오류 발생 시 예외 처리
    @MainActor
    public func deleteExpiredBanners() throws {
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<AdBannerList>()
        let bannerLists = try context.fetch(descriptor)
        
        for bannerList in bannerLists {
            context.delete(bannerList)
        }
        
        try context.save()
        print("✅ 만료된 배너 데이터 삭제 완료: \(bannerLists.count)개")
    }
    
    // MARK: - Private Methods
    
    /// ✅ 광고 배너 리스트를 가져오거나 새로 생성
    /// - Parameter context: SwiftData 컨텍스트
    /// - Returns: `AdBannerList` 객체
    /// - Throws: SwiftData 불러오기 오류 발생 시 예외 처리
    private func fetchOrCreateBannerList(in context: ModelContext) throws -> AdBannerList {
        let descriptor = FetchDescriptor<AdBannerList>()
        let bannerLists = try context.fetch(descriptor)
        
        if let existingList = bannerLists.first {
            return existingList
        }
        
        let newBannerList = AdBannerList(wineList: [], timestamp: nil)
        context.insert(newBannerList)
        try context.save() // ✅ 새로 생성한 데이터 즉시 저장
        return newBannerList
    }
    
    /// ✅ 광고 배너 데이터가 만료되었는지 확인
    /// - Parameter context: SwiftData 컨텍스트
    /// - Returns: 데이터가 만료되었으면 `true`, 유효하면 `false`
    /// - Throws: SwiftData 불러오기 오류 발생 시 예외 처리
    private func isBannerDataExpired(in context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<AdBannerList>()
        let bannerLists = try context.fetch(descriptor)
        
        guard let bannerList = bannerLists.first else {
            return true // 데이터가 없으면 만료된 것으로 간주
        }
        
        if let listDate = bannerList.timestamp { // 시간 있으면
            return listDate < Calendar.current.startOfDay(for: Date()) // 💡 정확한 만료 조건 수정
        }
        
        return true // 날짜가 없으면 만료로 간주
    }
    
    /// ✅ SwiftData의 저장소 경로 반환 (UserData와 다른 경로)
    /// - Returns: `ad_banner.store` 파일 경로 (Application Support)
    private static func storeURL() -> URL {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupportURL.appendingPathComponent("ad_banner.store")
    }
}

// MARK: - 에러 정의

/// AdBannerListManager 관련 오류 정의
public enum AdBannerListError: Error {
    /// 저장된 배너 리스트를 찾을 수 없음
    case bannerListNotFound
    /// 배너 리스트가 만료됨
    case bannerListExpired
}

extension AdBannerListError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .bannerListNotFound:
            return "🚨 [오류] 배너 리스트를 찾을 수 없습니다."
        case .bannerListExpired:
            return "🚨 [오류] 배너 리스트가 만료되었습니다. 새 데이터를 요청하세요."
        }
    }
}
