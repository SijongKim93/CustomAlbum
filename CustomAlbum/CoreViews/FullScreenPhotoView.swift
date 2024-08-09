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
                GeometryReader { geometry in
                    let topOffset = viewModel.showInfoView ? -geometry.size.height * 0.15 : 0
                    
                    Image(uiImage: viewModel.currentPhoto.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        .clipped()
                        .background(Color.black)
                        .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)
                        .offset(y: topOffset)
                        .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                
                if viewModel.showInfoView {
                    InfoView(photo: viewModel.currentPhoto)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                }
                
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
                    .animation(.easeInOut(duration: 0.3), value: viewModel.showFavoriteAnimation)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: Button("편집") {
            // 편집 액션
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}
