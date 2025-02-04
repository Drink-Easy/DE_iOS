import Foundation
import XCTest
import Network

@testable import DRINKIG

final class DETests: XCTestCase {
    
    let authService = AuthService()
    
    func testLogin() async {
        let loginMockData = authService.makeLoginDTO(username: "Test@g.com", password: "test1234@")
        
        do {
            let response = try await authService.login(data: loginMockData)
            XCTAssertNotNil(response, "로그인 응답이 nil입니다!") // ✅ 응답 확인
            print("✅ 로그인 성공: \(response)")
        } catch {
            XCTFail("로그인 실패: \(error.localizedDescription)")
        }
    }
    
    func testLogout() async {
        do {
            let response = try await authService.logout()
            XCTAssertNotNil(response, "로그아웃 응답이 nil입니다!") // ✅ 응답 확인
            print("✅ 로그아웃 성공")
        } catch {
            XCTFail("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
}
