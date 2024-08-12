//
//  AdjustmentButton.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct AdjustmentButton: View {
    let title: String
    let systemImageName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .white : .gray)
                    .background(isSelected ? Color(UIColor.systemIndigo) : Color.clear)
                    .cornerRadius(8)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
}
