//
//  EditBottomView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/10/24.
//

import SwiftUI

struct EditBottomView: View {
    @ObservedObject var viewModel: EditImageViewModel
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    @Binding var rotationAngle: CGFloat

    var body: some View {
        VStack {
            if viewModel.selectedAction != nil {
                EditActionView(selectedAction: $viewModel.selectedAction, editViewModel: viewModel, cropRect: $cropRect, imageViewSize: $imageViewSize, rotationAngle: $rotationAngle)
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
                            .foregroundColor(.black)
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
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleCollage()
                    }
                }) {
                    VStack {
                        Image(systemName: "rectangle.3.offgrid")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.togglePortraitMode()
                    }
                }) {
                    VStack {
                        Image(systemName: "person.crop.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .ignoresSafeArea()
        }
    }
}
