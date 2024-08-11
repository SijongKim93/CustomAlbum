//
//  CropToolView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct CropOptionsView: View {
    @ObservedObject var editViewModel: EditImageViewModel
    @Binding var cropRect: CGRect
    @Binding var imageViewSize: CGSize
    
    var body: some View {
        HStack(spacing: 30) {
            CropOptionButton(optionName: "1:1") {
                editViewModel.setCropAspectRatio(1, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = editViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "4:3") {
                editViewModel.setCropAspectRatio(4.0 / 3.0, imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = editViewModel.cropRect
                }
            }
            
            CropOptionButton(optionName: "좌회전") {
                editViewModel.rotateImageLeft()
            }
            
            CropOptionButton(optionName: "우회전") {
                editViewModel.rotateImageRight()
            }
            
            CropOptionButton(optionName: "초기화") {
                editViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: imageViewSize)
                DispatchQueue.main.async {
                    self.cropRect = editViewModel.cropRect
                }
                print("초기화 눌림, cropRect: \(cropRect)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onChange(of: imageViewSize) { _, newSize in
            editViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: newSize)
            self.cropRect = editViewModel.cropRect
        }
    }
}
