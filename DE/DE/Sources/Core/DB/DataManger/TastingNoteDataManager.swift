// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class TastingNoteDataManager {
    public static let shared = TastingNoteDataManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: TastingNoteList.self, TastingNote.self,
                configurations: configuration
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    // MARK: - Methods
    
    @MainActor
    /// 특정 와인 종류에 따라 테이스팅 노트를 필터링하여 가져옵니다.
    /// - Parameters:
    ///   - userId: 테이스팅 노트를 조회할 사용자의 ID.
    ///   - sort: 필터링할 와인 종류(예: 레드, 화잍, 주정강화, 스파클링, 로제, 기타).
    /// - Returns: 지정된 종류에 해당하는 `TastingNote` 배열.
    /// - Throws:
    ///   - `TastingNoteError.userNotFound`: 사용자가 존재하지 않을 경우.
    ///   - `TastingNoteError.tastingNoteNotFound`: 사용자의 테이스팅 노트가 없을 경우.
    public func fetchTastingNotes(for userId: Int, sort: String) async throws -> [TastingNote] {
        let context = container.mainContext
        let user = try fetchUser(by: userId, in: context)
        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        let filteredNotes = noteList.noteList?.filter { $0.sort == sort } ?? []

        return filteredNotes
    }
    
    /// 새로운 테이스팅 노트 리스트를 생성하고 사용자의 데이터와 연결합니다.
    /// - Parameter userId: 테이스팅 노트 리스트를 생성할 사용자의 ID.(= 현재 로그인한 유저)
    /// - Throws:
    ///   - `TastingNoteError.userNotFound`: 사용자가 존재하지 않을 경우.
    ///   - `TastingNoteError.saveFailed`: 테이스팅 노트 리스트를 저장하는 데 실패한 경우.
    @MainActor
    public func createTastingNoteList(for userId: Int) async throws {
        let context = container.mainContext
        // 검증
        let user = try fetchUser(by: userId, in: context)
        if user.tastingNoteList != nil {
            throw TastingNoteError.saveFailed(reason: "이미 테이스팅 노트 리스트가 존재합니다.")
        }
        
        // 생성, 유저 연결
        let newNoteList = TastingNoteList(user: user)
        user.tastingNoteList = newNoteList

        do {
            try context.save()
            print("✅ 새로운 테이스팅 노트 리스트가 생성되었습니다!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 특정 사용자의 테이스팅 노트를 업데이트합니다.
    /// - Parameters:
    ///   - userId: 테이스팅 노트를 업데이트할 사용자의 ID.
    ///   - notes: 기존 노트를 대체할 `TastingNote` 배열.
    /// - Throws:
    ///   - `TastingNoteError.userNotFound`: 사용자가 존재하지 않을 경우.
    ///   - `TastingNoteError.tastingNoteNotFound`: 사용자의 테이스팅 노트가 없을 경우.
    ///   - `TastingNoteError.saveFailed`: 테이스팅 노트를 저장하는 데 실패한 경우.
    @MainActor
    public func updateTastingNotes(for userId: Int, notes: [TastingNote]) async throws {
        let context = container.mainContext

        let user = try fetchUser(by: userId, in: context)
        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        // 리스트 업데이트
        noteList.noteList = notes

        do {
            try context.save()
            print("✅ 테이스팅 노트 리스트가 업데이트되었습니다!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 특정 사용자의 테이스팅 노트 리스트를 삭제합니다.
    /// - Parameter userId: 테이스팅 노트를 삭제할 사용자의 ID.
    /// - Throws:
    ///   - `TastingNoteError.userNotFound`: 사용자가 존재하지 않을 경우.
    ///   - `TastingNoteError.tastingNoteNotFound`: 사용자의 테이스팅 노트가 없을 경우.
    ///   - `TastingNoteError.saveFailed`: 테이스팅 노트를 삭제하는 데 실패한 경우.
    @MainActor
    public func deleteTastingNoteList(for userId: Int) async throws {
        let context = container.mainContext

        let user = try fetchUser(by: userId, in: context)

        guard let noteList = user.tastingNoteList else {
            throw TastingNoteError.tastingNoteNotFound
        }

        // 3. 리스트 삭제
        context.delete(noteList)
        user.tastingNoteList = nil // 유저와의 관계 해제

        do {
            try context.save()
            print("✅ 테이스팅 노트 리스트가 삭제되었습니다!")
        } catch {
            throw TastingNoteError.saveFailed(reason: error.localizedDescription)
        }
    }

    
    // MARK: - 내부 함수
    @MainActor
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw TastingNoteError.userNotFound
        }
        
        return user
    }
}

public enum TastingNoteError: Error {
    case userNotFound
    case tastingNoteNotFound
    case saveFailed(reason: String)
    case unknown
}

extension TastingNoteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .tastingNoteNotFound:
            return "유저의 테이스팅 노트를 찾을 수 없습니다."
        case .saveFailed(let reason):
            return "데이터를 저장하는데 실패했습니다. 이유: \(reason)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
