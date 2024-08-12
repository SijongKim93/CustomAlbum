//
//  EditActionView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI


enum EditAction {
    case filter
    case crop
    case adjustment
    case blur
}

struct EditActionView: View {
    @Binding var selectedAction: EditAction?
    @StateObject var editViewModel: EditImageViewModel
    @ObservedObject var adjustViewModel: AdjustmentViewModel
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    @Binding var rotationAngle: CGFloat
    
    
    
    var body: some View {
        VStack {
            if let action = selectedAction {
                switch action {
                case .filter:
                    FilterScrollView(editViewModel: editViewModel)
                case .crop:
                    CropOptionsView(editViewModel: editViewModel, cropRect: $cropRect, imageViewSize: $imageViewSize)
                case .adjustment:
                    AdjustmentView(viewModel: adjustViewModel)
                case .blur:
                    Text("블러 효과를 적용 중입니다. \n화면을 터치하여 블러를 적용하세요.")
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .transition(.move(edge: .bottom))
    }
    
    
    private func setCropBoxAspectRatio(_ ratio: CGFloat) {
            let width = min(imageViewSize.width, imageViewSize.height * ratio)
            let height = width / ratio
            cropRect = CGRect(
                x: (imageViewSize.width - width) / 2,
                y: (imageViewSize.height - height) / 2,
                width: width,
                height: height
            )
        }

        private func setCropBoxToOriginalAspectRatio() {
            cropRect = CGRect(
                x: 0,
                y: 0,
                width: imageViewSize.width,
                height: imageViewSize.height
            )
        }
        
        private func resetCropBox() {
            cropRect = CGRect(
                x: 20,
                y: 20,
                width: imageViewSize.width - 40,
                height: imageViewSize.height - 40
            )
        }
}
