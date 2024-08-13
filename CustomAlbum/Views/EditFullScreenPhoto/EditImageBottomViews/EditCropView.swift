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
        } // 각각의 사이즈를 제공해 클립 박스를 변경할 수 있도록 구현했습니다.
        .frame(maxWidth: .infinity)
        .padding()
        .onChange(of: imageViewSize) { _, newSize in
            cropViewModel.setCropBoxToOriginalAspectRatio(imageViewSize: newSize)
            self.cropRect = cropViewModel.cropRect
        }
        /*
         imageViewSize를 사용해 크롭 박스를 원본 이미지의 비율에 맞게 다시 설정하는 로직입니다.
         예를 들어 이미지가 가로로 더 길다면 크롭 박스도 이에 맞춰 더 넓어지게 조정 됩니다.
         
         cropRect는 현재 뷰에서 사용하는 크롭박스의 위치와 크기를 나타냅니다.
         self.cropRect = cropViewModel.cropRect를 통해 화면에 표시되는 크롭 박스가 항상 최신 크기와 위치를 반영하도록 합니다.
         */
    }
}

