//// Copyright © 2024 DRINKIG. All rights reserved
//
//import SwiftUI
//
//import CoreModule
//import Network
//
//struct ListView: View {
//    var profile: MemberInfoResponse
//    
//    var infoItems: [(String, String)] {
//        [
//            ("닉네임", profile.username ?? "설정되지 않음"),
//            ("내 동네", profile.city ?? "설정되지 않음"),
//            ("이메일", profile.email ?? "이메일 없음"),
//            ("연동 상태", profile.authType ?? "알 수 없음"),
//            ("성인 인증", profile.adult ? "인증 완료" : "미인증")
//        ]
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            ForEach(Array(infoItems.enumerated()), id: \.offset) { index, item in
//                if index > 0 { Divider() }
//                InfoRow(title: item.0, value: item.1)
//                    .foregroundColor(index == 1 || index == 2 ? .gray : .black) // Conditional color
//            }
//        }
//        .padding()
//        .background(.white) // Background with light gray
//        .cornerRadius(10) // Rounded corners
//        .padding(.horizontal)
//    }
//}
//
//struct InfoRow: View {
//    var title: String
//    var value: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.body)
//                .foregroundColor(.black)
//            
//            Spacer()
//            
//            Text(value)
//                .font(.body)
//                .foregroundColor(.gray)
//        }
//        .padding(.vertical, 10)
//    }
//}
