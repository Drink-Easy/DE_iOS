// Copyright © 2024 DRINKIG. All rights reserved

import CoreModule
import UIKit

enum CharacteristicType: String {
    case sweetness = "당도"
    case acid = "산도"
    case tannin = "타닌"
    case bodied = "바디"
    case alcohol = "알코올"
}

struct RadarChartData {
    let type: CharacteristicType
    let value: Int
}

class CustomUIBezierPath: UIBezierPath {
    
    var movePoint: CGPoint?
    
    override func move(to point: CGPoint) {
        super.move(to: point)
        movePoint = point
    }
}

class PolygonChartView: UIButton {
    
    var dataList: [RadarChartData]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let chartTypes = [CharacteristicType.sweetness, CharacteristicType.acid, CharacteristicType.tannin, CharacteristicType.bodied, CharacteristicType.alcohol]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear // 배경색 설정
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(hex: "#7213B133") // 배경색 설정
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        
        let font = UIFont.systemFont(ofSize: 14)
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        var radian: Double = 0
        let step = 5 // 데이터 가이드 라인은 5단계로 표시한다
        var stepLinePaths = [CustomUIBezierPath]() // 각 단계별 가이드 라인
        for _ in 0 ..< step {
            stepLinePaths.append(CustomUIBezierPath())
        }
        let heightMaxValue = rect.height / 2 * 0.8 // RadarChartView영역내에 모든 그림이 그려지도록 max value가 그려질 높이
        let heightStep = heightMaxValue / CGFloat(step) // 1단계에 해당하는 높이
        let cx = rect.midX
        let cy = rect.midY
        let x = rect.midX
        let y = rect.midY - heightMaxValue
        let valuePath = UIBezierPath() // 각 특성값을 이어 구성할 다각형 path
        chartTypes.forEach { type in
            
            // 2. 각 꼭지점 부근에 각 특성 문자열 표시
            let point = transformRotate(radian: radian, x: x, y: y * 0.5, cx: cx, cy: cy)
            if let value = dataList?.first(where: { $0.type == type })?.value {
                let percentageValue = Int(value) //Int((Double(value) / 10) * 100)
                let strValue = "\(type.rawValue)\n\(percentageValue)"
                let attributedString = NSMutableAttributedString(string: strValue, attributes: attrs)
                if let range = strValue.range(of: "\(percentageValue)") {
                    let nsRange = NSRange(range, in: strValue)
                    attributedString.addAttribute(.foregroundColor, value: AppColor.purple100 ?? .red, range: nsRange) // 원하는 색상 적용
                }
                let size = attributedString.size()
                
                // 문자열 그리기
                attributedString.draw(
                    with: CGRect(x: point.x - size.width / 2, y: point.y - size.height / 2, width: size.width, height: size.height),
                    options: .usesLineFragmentOrigin,
                    context: nil
                )
            }
            
            // 3. 단계별 가이드 라인 path 설정
            stepLinePaths.enumerated().forEach { index, path in
                let point = transformRotate(radian: radian, x: x, y: y + heightStep * CGFloat(index), cx: cx, cy: cy)
                if path.isEmpty {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            // 4. 각 특성별 값에 해당하는 좌표를 구해 다각형 path 구성
            if let value = dataList?.first(where: { $0.type == type })?.value {
                let scaledValue = CGFloat(value - 20) / 80  // 슬라이더 값이 0-10이므로 0-100 범위로 변환 20, 40, 60, 80, 100 -> 1, 2, 3, 4, 5
                let convValue = heightMaxValue * scaledValue // 전달된 값을 차트 크기에 맞게 변환
                let point = transformRotate(radian: radian, x: x, y: rect.midY - convValue, cx: cx, cy: cy)
                if valuePath.isEmpty {
                    valuePath.move(to: point)
                } else {
                    valuePath.addLine(to: point)
                }
            }
            
            radian += .pi * 2 / Double(chartTypes.count)
        }
        
        stepLinePaths.enumerated().forEach { index, path in
            // 5. 단계별 가이드 라인 그리기
            UIColor(hex: "C1C1C1")!.setStroke()
            path.close()
            path.stroke()
        }
        
        // 7. 각 특성별 값을 다각형으로 표시
        UIColor(hex: "#7213B133")!.setFill()
        valuePath.close()
        valuePath.fill()
    }
    
    // 점(x, y)를 특정 좌표(cx, cy)를 중심으로 radian만큼 회전시킨 점의 좌표를 반환
    private func transformRotate(radian: Double, x: CGFloat, y: CGFloat, cx: CGFloat, cy: CGFloat) -> CGPoint {
        let x2 = cos(radian) * Double(x - cx) - sin(radian) * Double(y - cy) + Double(cx)
        let y2 = sin(radian) * Double(x - cx) + cos(radian) * Double(y - cy) + Double(cy)
        
        return CGPoint(x: x2, y: y2)
    }
    
}
