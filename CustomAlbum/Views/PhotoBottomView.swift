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
                    Image(systemName: "star")
                        .font(.system(size: 24))
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
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea()
    }
}

struct FullScreenBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBottomView(
            onShare: {},
            onFavorite: {},
            onInfo: {},
            onDelete: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
