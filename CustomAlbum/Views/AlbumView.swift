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
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isAuthorized {
                    if viewModel.photos.isEmpty {
                        Text("사진이 없습니다.")
                    } else {
                        PhotoGrid(photos: viewModel.photos)
                    }
                } else {
                    DeniedView(requestPermission: viewModel.checkAndRequestPermission)
                }            }
            .navigationTitle("My Album")
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
