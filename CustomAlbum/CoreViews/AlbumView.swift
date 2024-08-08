//
//  AlbumView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Foundation
import SwiftUI

struct AlbumView: View {
    @StateObject private var viewModel = AlbumViewModel()
    @Namespace private var animation
    @State private var selectedPhoto: Photo?
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if viewModel.isAuthorized {
                        if viewModel.photos.isEmpty {
                            Text("사진이 없습니다.")
                        } else {
                            PhotoGrid(photos: viewModel.photos, columns: columns, selectedPhoto: $selectedPhoto, animation: animation)
                        }
                    } else {
                        DeniedView(requestPermission: viewModel.checkAndRequestPermission)
                    }
                }
                .navigationTitle(selectedPhoto == nil ? "My Album" : "")
                .background(Color.primary.colorInvert())
                
                if let photo = selectedPhoto {
                    FullScreenPhotoView(photo: photo, isPresented: Binding(
                        get: { selectedPhoto != nil },
                        set: { if !$0 {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedPhoto = nil
                            }
                        }}
                    ), animation: animation)
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            viewModel.checkAndRequestPermission()
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
