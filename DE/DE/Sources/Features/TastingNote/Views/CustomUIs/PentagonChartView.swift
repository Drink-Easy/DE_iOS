// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI
import PolyKit

struct PentagonChartView: View {
    @State private var values: [Double] = [50, 50, 50, 50, 50]
    
    var body: some View {
        VStack {
            ZStack {
                // ✅ 배경 가이드 라인 (고정된 5각형)
                ForEach(0..<5) { i in
                    Polygon(count: 5, cornerRadius: 9.56)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: CGFloat(250 - i * 40), height: CGFloat(250 - i * 40))
                }
                
                // ✅ 슬라이더 값에 따라 변하는 내부 그래프
                RadarShape(values: values)
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 250, height: 250)
            }
            .frame(width: 300, height: 300)
            .background(Color.clear)
            
//            // ✅ 슬라이더 5개 배치 (각 슬라이더가 꼭짓점에 대응)
//            let labels = ["당도", "산도", "타닌", "바디", "알코올"]
//            ForEach(0..<5, id: \.self) { i in
//                HStack {
//                    Text(labels[i])
//                        .frame(width: 50)
//                    Slider(value: $values[i], in: 0...100)
//                }
//                .padding()
//            }
        }
    }
}

struct RadarShape: Shape {
    var values: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.midX
        let centerY = rect.midY
        let radius: CGFloat = min(rect.width, rect.height) / 2
        
        let angles: [CGFloat] = [270, 342, 54, 126, 198]
        
        // ✅ 첫 번째 꼭짓점으로 이동
        let firstPoint = CGPoint(
            x: centerX + radius * CGFloat(values[0] / 100) * cos(angles[0] * .pi / 180),
            y: centerY + radius * CGFloat(values[0] / 100) * sin(angles[0] * .pi / 180)
        )
        path.move(to: firstPoint)
        
        // ✅ 나머지 꼭짓점 연결
        for i in 1..<values.count {
            let point = CGPoint(
                x: centerX + radius * CGFloat(values[i] / 100) * cos(angles[i] * .pi / 180),
                y: centerY + radius * CGFloat(values[i] / 100) * sin(angles[i] * .pi / 180)
            )
            path.addLine(to: point)
        }
        
        // ✅ 마지막 꼭짓점에서 시작점으로 닫기
        path.closeSubpath()
        
        return path
    }
}
