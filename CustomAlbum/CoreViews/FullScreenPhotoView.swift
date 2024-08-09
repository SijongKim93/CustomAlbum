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
                }
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: Button("편집") {
            // 편집 액션
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}
