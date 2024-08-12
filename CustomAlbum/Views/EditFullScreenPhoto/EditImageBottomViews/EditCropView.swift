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
            CropOptionButton(optionName: "1:1") {
                cropViewModel.setCropAspectRatio(1, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = cropViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "4:3") {
                cropViewModel.setCropAspectRatio(4.0 / 3.0, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = cropViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "좌회전") {
                if cropViewModel.rotateImageLeft(UIImage()) != nil {
                }
            }
            
            CropOptionButton(optionName: "우회전") {
                if cropViewModel.rotateImageRight(UIImage()) != nil {
                }
            }
            
            CropOptionButton(optionName: "초기화") {
                cropViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = cropViewModel.cropRect
                }
                print("초기화 눌림, cropRect: \(cropRect)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onChange(of: imageViewSize) { _, newSize in
            cropViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: newSize)
            self.cropRect = cropViewModel.cropRect
        }
    }
}
