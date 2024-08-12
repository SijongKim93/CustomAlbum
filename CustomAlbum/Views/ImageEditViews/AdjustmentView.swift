//
//  AdjustmentView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct AdjustmentView: View {
    @StateObject var viewModel: AdjustmentViewModel
    @State private var selectedAdjustment: String = "선명도"
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    AdjustmentButton(title: "선명도", systemImageName: "eyedropper.halffull", isSelected: selectedAdjustment == "선명도") {
                        selectedAdjustment = "선명도"
                    }
                    AdjustmentButton(title: "노출", systemImageName: "sun.max.fill", isSelected: selectedAdjustment == "노출") {
                        selectedAdjustment = "노출"
                    }
                    AdjustmentButton(title: "생동감", systemImageName: "drop.fill", isSelected: selectedAdjustment == "생동감") {
                        selectedAdjustment = "생동감"
                    }
                    AdjustmentButton(title: "하이라이트", systemImageName: "sunrise.fill", isSelected: selectedAdjustment == "하이라이트") {
                        selectedAdjustment = "하이라이트"
                    }
                    AdjustmentButton(title: "밝기", systemImageName: "sun.min.fill", isSelected: selectedAdjustment == "밝기") {
                        selectedAdjustment = "밝기"
                    }
                    AdjustmentButton(title: "대비", systemImageName: "circle.lefthalf.fill", isSelected: selectedAdjustment == "대비") {
                        selectedAdjustment = "대비"
                    }
                    AdjustmentButton(title: "채도", systemImageName: "drop.fill", isSelected: selectedAdjustment == "채도") {
                        selectedAdjustment = "채도"
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            
            Stepper(value: bindingForSelectedAdjustment(), in: rangeForSelectedAdjustment(), step: 0.5) {
                Text("\(selectedAdjustment): \(bindingForSelectedAdjustment().wrappedValue, specifier: "%.1f")")
                    .foregroundColor(.white)
            }
            .accentColor(Color(UIColor.systemIndigo))
            .onChange(of: bindingForSelectedAdjustment().wrappedValue) { _, newValue in
                print("\(selectedAdjustment) 값: \(newValue)")
                viewModel.applyToCurrentImage()
            }
            .padding()
        }
        .padding(.vertical, 10)
        .background(Color.black)
    }
    
    private func bindingForSelectedAdjustment() -> Binding<Double> {
        switch selectedAdjustment {
        case "선명도":
            return $viewModel.sharpness
        case "노출":
            return $viewModel.exposure
        case "생동감":
            return $viewModel.vibrance
        case "하이라이트":
            return $viewModel.highlight
        case "밝기":
            return $viewModel.brightness
        case "대비":
            return $viewModel.contrast
        case "채도":
            return $viewModel.saturation
        default:
            return $viewModel.sharpness
        }
    }
    
    private func rangeForSelectedAdjustment() -> ClosedRange<Double> {
        switch selectedAdjustment {
        case "선명도":
            return -10.0...10.0
        case "노출":
            return -2.0...2.0
        case "생동감":
            return -1.0...1.0
        case "하이라이트":
            return 0.0...1.0
        case "밝기":
            return -1.0...1.0
        case "대비":
            return 0.5...1.5
        case "채도":
            return 0.0...2.0
        default:
            return -1.0...1.0
        }
    }
}
