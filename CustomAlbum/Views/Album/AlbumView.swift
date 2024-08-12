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
    @State private var selectedPhotoIndex: Int?
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
                },
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
            viewModel.refreshPhotos()
        }
        .onChange(of: selectedPhotoIndex) { newValue, oldValue in
            viewModel.refreshPhotos()
        }
    }
}
