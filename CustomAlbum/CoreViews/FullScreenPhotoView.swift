//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    let photo: Photo
    @Binding var isPresented: Bool
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: photo.id, in: animation)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .transition(.opacity)
    }
}
