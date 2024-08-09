//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    @ObservedObject var viewModel: FullScreenPhotoViewModel
    @Binding var isPresented: Bool
    var animation: Namespace.ID
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            Image(uiImage: viewModel.currentPhoto.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            if abs(gesture.translation.height) > 100 {
                                withAnimation(.spring()) {
                                    isPresented = false
                                }
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = .zero
                                }
                            }
                        }
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { gesture in
                            if gesture.translation.width > 50 {
                                viewModel.showPreviousPhoto()
                            } else if gesture.translation.width < -50 {
                                viewModel.showNextPhoto()
                            }
                        }
                )
                .animation(.spring(), value: dragOffset)
                .animation(.spring(), value: isPresented)
            
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
