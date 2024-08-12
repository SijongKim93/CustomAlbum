//
//  AdjustmentControlView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct AdjustmentControlView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let isSelected: Bool
    let action: () -> Void
    let onChange: () -> Void

    var body: some View {
        VStack {
            Button(action: action) {
                Text(title)
                    .fontWeight(.bold)
                    .padding()
                    .background(isSelected ? Color.blue : Color.clear)
                    .cornerRadius(8)
                    .foregroundColor(isSelected ? .white : .black)
            }
            
            if isSelected {
                Slider(value: $value, in: range, onEditingChanged: { _ in
                    onChange()
                })
                .padding([.leading, .trailing])
            }
        }
    }
}

