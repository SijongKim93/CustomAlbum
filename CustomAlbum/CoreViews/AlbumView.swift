//
//  AlbumView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct AlbumView: View {
    @StateObject private var viewModel = AlbumViewModel()
    @Namespace private var animation
    @State private var selectedPhotoIndex: Int?

    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if viewModel.isAuthorized {
                        if viewModel.photos.isEmpty {
                            Text("사진이 없습니다.")
                        } else {
                            PhotoGrid(
                                photos: viewModel.photos,
                                columns: columns,
                                selectedPhotoIndex: $selectedPhotoIndex,
                                animation: animation,
                                onScrolledToEnd: { photo in
                                    viewModel.loadMoreIfNeeded(currentItem: photo)
                                }
                            )
                        }
                    } else {
                        DeniedView(requestPermission: viewModel.checkAndRequestPermission)
                    }
                }
                .navigationTitle("My Album")
                .background(Color.primary.colorInvert())
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedPhotoIndex != nil },
                set: { if !$0 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedPhotoIndex = nil
                    }
                }}
            )) {
                if let index = selectedPhotoIndex {
                    FullScreenPhotoView(
                        viewModel: FullScreenPhotoViewModel(photos: viewModel.photos, initialIndex: index),
                        animation: animation
                    )
                }
            }
        }
        .task {
            viewModel.checkAndRequestPermission()
        }
        .onAppear {
            if viewModel.isAuthorized {
                viewModel.fetchPhotosIfAuthorized()
            }
        }
    }
}
