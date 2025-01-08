// Copyright © 2024 DRINKIG. All rights reserved

import SwiftUI
import CoreModule

struct CustomSliderWrapper: UIViewRepresentable {
    @Binding var value: Double
    let label: String

    func makeUIView(context: Context) -> CustomStepSlider {
        let slider = CustomStepSlider(text1: label)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: CustomStepSlider, context: Context) {
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CustomSliderWrapper

        init(_ parent: CustomSliderWrapper) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: CustomStepSlider) {
            parent.value = Double(sender.value)
        }
    }
}
