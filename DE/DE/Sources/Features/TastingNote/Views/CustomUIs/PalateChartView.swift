// Copyright © 2024 DRINKIG. All rights reserved

import SwiftUI
import Charts

struct RadarData {
    let label: String
    let value: Double // 0.0 ~ 1.0
}

struct PalateChartView: View {
    @ObservedObject var viewModel: PalateViewModel
    
    let maxValue: Double = 1.0 // 최대값을 1.0으로 정규화
    let levels: Int = 5        // 5단계
    let spacing: CGFloat = 26  // 각 단계 간 간격 (30 포인트)
    
    var body: some View {
        ZStack {
            // 단계별 다각형과 레이블
            ForEach(1...levels, id: \.self) { level in
                let radius = spacing * CGFloat(level) // 각 단계별 반경 계산
                PolygonShape(sides: viewModel.stats.count, scale: radius / (spacing * CGFloat(levels)))
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
//                // 단계별 레이블 추가
//                if level < levels {
//                    GeometryReader { geometry in
//                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
//                        Text("\(level * 20)") // 20, 40, 60, 80
//                            .font(.system(size: 12, weight: .medium))
//                            .foregroundColor(.gray)
//                            .position(x: center.x, y: center.y - radius - 10)
//                    }
//                }
            }
            
            let dataValues = viewModel.stats.map { $0.value / maxValue }
            let sides = viewModel.stats.count
            
            // 데이터 레이어
            PolygonShape(
                sides: sides,
                scale: 1.0,
                values: dataValues
            )
            .fill(Color("purple100").opacity(0.2))
            
            // 꼭짓점에 점 추가
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = spacing * CGFloat(levels)
                
                ForEach(0..<sides, id: \.self) { index in
                    // 각 꼭짓점 위치 계산
                    let angle = Double(index) / Double(sides) * 2 * .pi - .pi / 2
                    let x = center.x + CGFloat(cos(angle)) * radius * CGFloat(dataValues[index])
                    let y = center.y + CGFloat(sin(angle)) * radius * CGFloat(dataValues[index])
                    
                    Circle()
                        .fill(Color("purple70"))
                        .frame(width: 6, height: 6) // 점의 크기
                        .position(x: x, y: y) // 계산된 꼭짓점 위치
                }
            }
            
            // 축 레이블
            ForEach(0..<viewModel.stats.count, id: \.self) { index in
                let rotationOffset = -90.0 // "당도"를 꼭대기에 배치하기 위한 회전 조정
                let angle = Double(index) / Double(viewModel.stats.count) * 360 + rotationOffset
                let textDistance: CGFloat = spacing * CGFloat(levels) + 27 // 다각형 외부로 텍스트를 배치할 거리
                
                GeometryReader { geometry in
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let x = center.x + cos(angle * .pi / 180) * textDistance
                    let y = center.y + sin(angle * .pi / 180) * textDistance
                    
                    Text("\(viewModel.stats[index].label)")
                        .font(.system(size: 14, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 60)
                        .position(x: x, y: y)
                    Text("\(Int(viewModel.stats[index].value * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("purple100"))
                        .frame(width: 60)
                        .position(x: x, y: y + 14) // 계산된 위치에 텍스트 배치
                }
            }
        }
        .frame(width: spacing * CGFloat(levels) * 2, height: spacing * CGFloat(levels) * 2)
        .padding()
    }
}

// PolygonShape 수정은 필요 없음 (scale 값만 반영)
struct PolygonShape: Shape {
    let sides: Int
    var scale: CGFloat = 1.0
    var values: [Double] = []
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2 * scale
        var path = Path()
        
        for i in 0..<sides {
            let angle = Double(i) / Double(sides) * 2 * .pi - .pi / 2
            let valueScale = values.isEmpty ? 1.0 : values[i]
            let x = center.x + CGFloat(cos(angle)) * radius * CGFloat(valueScale)
            let y = center.y + CGFloat(sin(angle)) * radius * CGFloat(valueScale)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}
