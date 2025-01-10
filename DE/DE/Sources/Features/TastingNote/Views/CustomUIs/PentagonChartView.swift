// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI
import PolyKit

struct PentagonChartView: View {
    @ObservedObject var values: SliderValues

    var body: some View {
        VStack {
            ZStack {
                // ✅ 배경 가이드 라인을 별도 메서드로 분리
                backgroundGuideLines()
                
                // ✅ 슬라이더 값에 따라 변하는 내부 그래프
                RadarShape(values: values.values)
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 250, height: 250)
            }
            .frame(width: 300, height: 300)
            .background(Color.clear)
        }
    }

    // ✅ 배경 가이드 라인 메서드로 분리
    private func backgroundGuideLines() -> some View {
        ForEach(0..<5) { i in
            Polygon(count: 5, cornerRadius: 9.56)
                .stroke(Color.gray, lineWidth: 1)
                .frame(width: CGFloat(250 - i * 50), height: CGFloat(250 - i * 50))
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
        let curveFactor: CGFloat = 0.15  // 곡률 조정

        // 첫 번째 꼭짓점으로 이동
        let firstPoint = pointAt(angle: angles[0], radius: radius * CGFloat(values[0] / 100), center: CGPoint(x: centerX, y: centerY))
        path.move(to: firstPoint)
        
        // 나머지 꼭짓점 연결
        for i in 0..<values.count {
            let nextIndex = (i + 1) % values.count
            let currentPoint = pointAt(angle: angles[i], radius: radius * CGFloat(values[i] / 100), center: CGPoint(x: centerX, y: centerY))
            let nextPoint = pointAt(angle: angles[nextIndex], radius: radius * CGFloat(values[nextIndex] / 100), center: CGPoint(x: centerX, y: centerY))

            // 곡선의 제어점 계산
            let controlPoint1 = CGPoint(
                x: currentPoint.x + (nextPoint.x - currentPoint.x) * curveFactor,
                y: currentPoint.y + (nextPoint.y - currentPoint.y) * curveFactor
            )
            let controlPoint2 = CGPoint(
                x: nextPoint.x - (nextPoint.x - currentPoint.x) * curveFactor,
                y: nextPoint.y - (nextPoint.y - currentPoint.y) * curveFactor
            )
            
            path.addCurve(to: nextPoint, control1: controlPoint1, control2: controlPoint2)
        }
        
        return path
    }

    // 각도와 반지름을 사용해 꼭짓점 좌표 계산
    private func pointAt(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
        CGPoint(
            x: center.x + radius * cos(angle * .pi / 180),
            y: center.y + radius * sin(angle * .pi / 180)
        )
    }
}
