//
//  EditBottomView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/10/24.
//

import SwiftUI

struct EditFullScreenPhotoBottomView: View {
    @ObservedObject var viewModel: EditImageViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @ObservedObject var adjustViewModel: EditAdjustmentViewModel
    @ObservedObject var blurViewModel: EditBlurViewModel
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
            }
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
                }
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
                }
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
                }
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
                }
                .padding()
            }
            .background(Color.white)
            .ignoresSafeArea()
        }
    }
}
