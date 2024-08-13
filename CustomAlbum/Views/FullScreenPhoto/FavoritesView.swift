//
//  FavoritesView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @EnvironmentObject var albumViewModel: AlbumViewModel
    @StateObject private var viewModel = FavoritesViewModel()
    @Namespace private var animation
    
    @State private var selectedPhotoIndex: Int? // 사용자가 선택한 사진의 인덱스를 추적합니다.
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            PhotoGrid(
                photos: viewModel.favoritePhotos,
                columns: columns,
                selectedPhotoIndex: $selectedPhotoIndex,
                animation: animation,
                imageForPhoto: { photo in
                    photo.image
                },
                isFavorite: { photo in
                    photo.isFavorite
                }
            )
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.loadFavoritePhotos()
        } // 뷰가 나타날 때 즐겨찾기 된 사진을 가져오는 로직입니다.
        .onChange(of: selectedPhotoIndex) { newValue, oldValue in
            viewModel.refreshFavoritePhotos()
        } // 선택된 사진의 인덱스가 변경될 때(사진 추가 및 삭제 등) 사진을 새로 가져옵니다.
        .navigationDestination(isPresented: Binding(
            get: { selectedPhotoIndex != nil },
            set: { if !$0 { selectedPhotoIndex = nil } }
        )) {
            if let index = selectedPhotoIndex {
                let selectedImage = viewModel.favoritePhotos[index].image
                let adjustmentViewModel = EditAdjustmentViewModel(image: selectedImage)
                let editFilterViewModel = EditFilterViewModel()
                let cropViewModel = EditCropViewModel(image: selectedImage)
                let editViewModel = EditImageViewModel(
                    image: selectedImage,
                    adjustmentViewModel: adjustmentViewModel,
                    filterViewModel: editFilterViewModel,
                    cropViewModel: cropViewModel, 
                    albumViewModel: albumViewModel
                )
                
                FullScreenPhotoView(
                    viewModel: FullScreenPhotoViewModel(
                        photos: viewModel.favoritePhotos,
                        initialIndex: index
                    ),
                    editViewModel: editViewModel,
                    adjustmentViewModel: adjustmentViewModel,
                    blurViewModel: EditBlurViewModel(image: selectedImage),
                    filterViewModel: editFilterViewModel,
                    cropViewModel: cropViewModel
                )
                .environmentObject(albumViewModel)
            } // 선택된 사진을 FullScreenPhotoView에 보이도록 하는 로직입니다.
        }
    }
}
