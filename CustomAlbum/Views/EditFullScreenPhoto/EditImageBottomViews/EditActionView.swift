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
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var blurViewModel: BlurViewModel
    @ObservedObject var cropViewModel: EditCropViewModel // 추가된 부분
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    @Binding var rotationAngle: CGFloat

    private var currentImage: UIImage {
        var finalImage = editViewModel.originalImage
        
        if let adjustedImage = adjustViewModel.adjustedImage {
            finalImage = adjustedImage
        }
        
        if let filteredImage = filterViewModel.filteredImage {
            finalImage = filteredImage
        }
        
        if let blurredImage = blurViewModel.bluredImage {
            finalImage = blurredImage
        }
        
        if editViewModel.selectedAction == .crop, cropViewModel.cropApplied {
            finalImage = cropViewModel.applyCrop(with: cropViewModel.cropRect, imageViewSize: imageViewSize, to: finalImage) ?? finalImage
        }
        
        return finalImage
    }
    
    var body: some View {
        VStack {
            if let action = selectedAction {
                switch action {
                case .filter:
                    EditFilterView(editFilterViewModel: filterViewModel, image: currentImage)
                case .crop:
                    EditCropView(cropViewModel: cropViewModel, cropRect: $cropRect, imageViewSize: $imageViewSize) // 수정된 부분
                case .adjustment:
                    EditAdjustmentView(viewModel: adjustViewModel)
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
}
