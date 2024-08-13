//
//  EditBottomView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/10/24.
//

import SwiftUI

struct EditFullScreenPhotoBottomView: View {
    // ViewModels를 ObservedObject로 사용하여 각각의 편집 상태를 관리합니다.
    @ObservedObject var viewModel: EditImageViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @ObservedObject var adjustViewModel: EditAdjustmentViewModel
    @ObservedObject var blurViewModel: EditBlurViewModel
    
    // 크롭 상태와 이미지 뷰 크기를 바인딩하여 편집 과정에서 동기화합니다.
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    @Binding var rotationAngle: CGFloat
    

    var body: some View {
        VStack {
            if viewModel.selectedAction != nil {
                EditActionView(
                    selectedAction: $viewModel.selectedAction,
                    editViewModel: viewModel,
                    adjustViewModel: adjustViewModel,
                    filterViewModel: filterViewModel,
                    blurViewModel: blurViewModel,
                    cropViewModel: cropViewModel,
                    cropRect: $cropRect,
                    imageViewSize: $imageViewSize,
                    rotationAngle: $rotationAngle
                )
            } // 사용자가 선택한 편집 작업에 따라 EditActionView를 표시합니다.
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.toggleFilter()
                    }
                }) {
                    VStack {
                        Image(systemName: "camera.filters")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.selectedAction == .filter ? Color(UIColor.systemIndigo) : .black)
                    }
                } // 필터 버튼 - 필터 편집 모드를 활성화합니다.
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleCrop()
                    }
                }) {
                    VStack {
                        Image(systemName: "crop")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.selectedAction == .crop ? Color(UIColor.systemIndigo) : .black)
                    }
                } // 크롭 버튼 - 크롭 편집 모드를 활성화합니다.
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleAdjustment()
                    }
                }) {
                    VStack {
                        Image(systemName: "microbe.circle")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.selectedAction == .adjustment ? Color(UIColor.systemIndigo) : .black)
                    }
                } // 조정 버튼 - 이미지 조정 모드를 활성화합니다.
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleBlur()
                    }
                }) {
                    VStack {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.selectedAction == .blur ? Color(UIColor.systemIndigo) : .black)
                    }
                } // 블러 버튼 - 블러 효과를 적용하는 모드를 활성화합니다.
                .padding()
            }
            .background(Color.white)
            .ignoresSafeArea()
        }
    }
}
