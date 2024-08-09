//
//  GestureHandlers.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct GestureHandlers {
    static func handleDrag(dragOffset: Binding<CGSize>, isPresented: Binding<Bool>) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                dragOffset.wrappedValue = gesture.translation
            }
            .onEnded { gesture in
                if abs(gesture.translation.height) > 100 {
                    withAnimation(.spring()) {
                        isPresented.wrappedValue = false
                    }
                } else {
                    withAnimation(.spring()) {
                        dragOffset.wrappedValue = .zero
                    }
                }
            }
    }
    
    static func handleSwipe(viewModel: FullScreenPhotoViewModel) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { gesture in
                if gesture.translation.width > 50 {
                    viewModel.showPreviousPhoto()
                } else if gesture.translation.width < -50 {
                    viewModel.showNextPhoto()
                }
            }
    }
}
