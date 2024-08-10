//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    @EnvironmentObject var albumViewModel: AlbumViewModel
    @StateObject var viewModel: FullScreenPhotoViewModel
    @StateObject private var zoomHandler = PhotoZoomHandler()
    var animation: Namespace.ID
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    let imageHeight = geometry.size.height * 0.65
                    let topOffset = viewModel.showInfoView ? -geometry.size.height * 0.15 : 0
                    
                    Image(uiImage: viewModel.currentPhoto.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        .clipped()
                        .background(Color.black)
                        .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)
                        .offset(y: topOffset)
                        .scaleEffect(zoomHandler.currentScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    zoomHandler.magnificationChanged(value)
                                }
                                .onEnded { value in
                                    zoomHandler.magnificationEnded(value)
                                }
                        )
                        .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    if viewModel.showInfoView {
                        InfoView(photo: viewModel.currentPhoto)
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.37)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                            .offset(y: imageHeight)
                    }
                }
                
                PhotoBottomView(
                    onShare: {
                        viewModel.toggleSharePhoto()
                    },
                    onFavorite: {
                        viewModel.toggleFavorite()
                    },
                    onInfo: {
                        viewModel.toggleInfo()
                    },
                    onDelete: {
                        viewModel.toggleDeletePhoto()
                    },
                    isFavorite: viewModel.currentPhoto.isFavorite
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxWidth: .infinity)
            
            if viewModel.showFavoriteAnimation {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.pink)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.1), value: viewModel.showFavoriteAnimation)
            }
               
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: Button("편집") {
            // 편집 액션
        })
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.shouldDismiss) {
            if viewModel.shouldDismiss {
                albumViewModel.removePhoto(by: viewModel.currentPhoto.id)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
