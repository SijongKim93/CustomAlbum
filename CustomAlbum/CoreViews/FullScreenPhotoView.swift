//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    @ObservedObject var viewModel: FullScreenPhotoViewModel
    var animation: Namespace.ID

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Image(uiImage: viewModel.currentPhoto.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)

                Spacer()

                PhotoBottomView(
                    onShare: {
                        viewModel.sharePhoto()
                    },
                    onFavorite: {
                        viewModel.toggleFavorite()
                    },
                    onInfo: {
                        viewModel.showPhotoInfo()
                    },
                    onDelete: {
                        viewModel.deletePhoto()
                    },
                    isFavorite: viewModel.currentPhoto.isFavorite
                )
                .ignoresSafeArea(edges: .bottom)
            }
            
            if viewModel.showFavoriteAnimation {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .transition(.scale)
                    .animation(.easeInOut(duration: 0.8), value: viewModel.showFavoriteAnimation)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: Button("편집") {
            // 편집 액션
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}
