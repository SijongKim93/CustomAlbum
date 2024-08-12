//
//  EditCropView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct EditCropView: View {
    @ObservedObject var cropViewModel: EditCropViewModel
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    
    var body: some View {
        HStack(spacing: 30) {
            CropOptionButton(optionName: "1:1", iconName: "square") {
                cropViewModel.setCropAspectRatio(1, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = cropViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "4:3", iconName: "rectangle") {
                cropViewModel.setCropAspectRatio(4.0 / 3.0, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = cropViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "좌회전", iconName: "rotate.left") {
                if cropViewModel.rotateImageLeft(UIImage()) != nil {
                }
            }
            
            CropOptionButton(optionName: "우회전", iconName: "rotate.right") {
                if cropViewModel.rotateImageRight(UIImage()) != nil {
                }
            }
            
            CropOptionButton(optionName: "자르기", iconName: "crop") {
                cropViewModel.applyCrop(imageViewSize: imageViewSize)
            }
            .foregroundColor(.green)
            
            CropOptionButton(optionName: "초기화", iconName: "arrow.counterclockwise") {
                cropViewModel.resetCropBox(imageViewSize: imageViewSize)
                self.cropRect = cropViewModel.cropRect
            }
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onChange(of: imageViewSize) { _, newSize in
            cropViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: newSize)
            self.cropRect = cropViewModel.cropRect
        }
    }
}

