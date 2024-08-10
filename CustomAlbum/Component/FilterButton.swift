//
//  FilterButton.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct FilterButton: View {
    var filterName: String
    var filterAction: () -> Void
    var image: UIImage

    var body: some View {
        Button(action: filterAction) {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                Text(filterName)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
