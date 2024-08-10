//
//  FullScreenBottomBar.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct PhotoBottomView: View {
    var onShare: () -> Void
    var onFavorite: () -> Void
    var onInfo: () -> Void
    var onDelete: () -> Void
    var isFavorite: Bool

    var body: some View {
        HStack {
            Button(action: onShare) {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24))
                }
            }
            .padding()
            
            Spacer()

            Button(action: onFavorite) {
                VStack {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorite ? .pink : .blue)
                }
            }
            .padding()
            
            Spacer()

            Button(action: onInfo) {
                VStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                }
            }
            .padding()
            
            Spacer()

            Button(action: onDelete) {
                VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}
