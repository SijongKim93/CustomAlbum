//
//  EditActionView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

// 편집 작업의 종류를 정의했습니다.
enum EditAction {
    case filter
    case crop
    case adjustment
    case blur
}

struct EditActionView: View {
    @Binding var selectedAction: EditAction?
    @StateObject var editViewModel: EditImageViewModel
    @ObservedObject var adjustViewModel: EditAdjustmentViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var blurViewModel: EditBlurViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    @Binding var rotationAngle: CGFloat
    
    /*
     현재 편집 중인 이미지를 가져오는 계산 속성입니다.
     편집 과정 중 각각의 상황별 이미지 적용 시 충돌 이슈가 있어 각각의 편집값이 제대로 들어갈 수 있도록 구현했습니다.
     */
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
            finalImage = cropViewModel.applyActionCrop(with: cropViewModel.cropRect, imageViewSize: imageViewSize, to: finalImage) ?? finalImage
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
            } // 편집 작업에 따라 관련 뷰를 표시 할 수 있도록 각각 해당 부분이 실행되도록 구현했습니다.
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .transition(.move(edge: .bottom))
    }
}
