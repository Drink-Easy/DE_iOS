// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

/// 🔥 테이스팅 노트(Tasting Note) 관리 싱글톤 매니저
public final class TastingNoteDataManager {
    
    /// 싱글톤 인스턴스
    public static let shared = TastingNoteDataManager()
    
    private init() {} // 외부 인스턴스 생성 방지

    // MARK: - Public Methods

    /// 🔹 특정 와인 종류에 따라 테이스팅 노트 필터링
    /// - Parameters:
    ///   - userId: 테이스팅 노트를 조회할 사용자의 ID
    ///   - sort: 필터링할 와인 종류 (예: 레드, 화이트, 주정강화, 스파클링, 로제, 기타)
    /// - Returns: 해당 와인 종류의 `TastingNote` 배열
    /// - Throws: `TastingNoteError.tastingNoteNotFound`
    @MainActor
    public func fetchTastingNotes(for userId: Int, sort: String) async throws -> [TastingNote] {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        return noteList.noteList?.filter { $0.sort == sort } ?? []
    }
    
    /// 🔹 새로운 테이스팅 노트 리스트 생성
    /// - Parameter userId: 테이스팅 노트 리스트를 생성할 사용자 ID
    /// - Throws: `TastingNoteError.saveFailed`
    @MainActor
    public func createTastingNoteList(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext
        
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        if user.tastingNoteList != nil {
            throw TastingNoteError.saveFailed(reason: "이미 테이스팅 노트 리스트가 존재합니다.")
        }
        
        let newNoteList = TastingNoteList(user: user)
        user.tastingNoteList = newNoteList

        do {
            try context.save()
            print("✅ 새로운 테이스팅 노트 리스트 생성 완료!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 🔹 특정 사용자의 테이스팅 노트 업데이트
    /// - Parameters:
    ///   - userId: 테이스팅 노트를 업데이트할 사용자 ID
    ///   - notes: 기존 노트를 대체할 `TastingNote` 배열
    /// - Throws: `TastingNoteError.tastingNoteNotFound`, `TastingNoteError.saveFailed`
    @MainActor
    public func updateTastingNotes(for userId: Int, notes: [TastingNote]) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        noteList.noteList = notes

        do {
            try context.save()
            print("✅ 테이스팅 노트 리스트 업데이트 성공!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 🔹 특정 사용자의 테이스팅 노트 리스트 삭제
    /// - Parameter userId: 테이스팅 노트를 삭제할 사용자 ID
    /// - Throws: `TastingNoteError.tastingNoteNotFound`, `TastingNoteError.saveFailed`
    @MainActor
    public func deleteTastingNoteList(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        context.delete(noteList)
        user.tastingNoteList = nil

        do {
            try context.save()
            print("✅ 테이스팅 노트 리스트 삭제 성공!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }
}

// MARK: - 에러 정의

public enum TastingNoteError: Error {
    /// 테이스팅 노트가 존재하지 않음
    case tastingNoteNotFound
    /// 데이터 저장 실패
    case saveFailed(reason: String)
}

extension TastingNoteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .tastingNoteNotFound:
            return "🚨 [오류] 테이스팅 노트가 존재하지 않습니다."
        case .saveFailed(let reason):
            return "🚨 [오류] 테이스팅 노트 저장 실패. 원인: \(reason)"
        }
    }
}
