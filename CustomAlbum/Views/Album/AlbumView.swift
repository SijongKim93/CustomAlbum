//
//  AlbumView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var viewModel: AlbumViewModel
    @Namespace private var animation
    @State private var selectedPhotoIndex: Int? // 사용자가 선택한 사진의 인덱스를 추적합니다.
    @Binding var tabSelection: Int

    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            PhotoGrid(
                photos: viewModel.photos,
                columns: columns,
                selectedPhotoIndex: $selectedPhotoIndex,
                animation: animation,
                onScrolledToEnd: { photo in
                    viewModel.loadMoreIfNeeded(currentItem: photo)
                }, // onScrolledToEnd를 활용해 스크롤 끝에 도착했을 때 추가 사진을 로드하는 로직입니다.
                imageForPhoto: { photo in
                    photo.image
                },
                isFavorite: { photo in
                    photo.isFavorite
                }
            )
            .navigationTitle("My Album")
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
