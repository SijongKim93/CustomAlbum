//
//  EditFullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/12/24.
//

import SwiftUI

struct EditFullScreenPhotoView: View {
    @ObservedObject var viewModel: FullScreenPhotoViewModel
    @ObservedObject var editViewModel: EditImageViewModel
    @ObservedObject var adjustmentViewModel: EditAdjustmentViewModel
    @ObservedObject var blurViewModel: EditBlurViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @StateObject private var zoomHandler = PhotoZoomHandler()
    var animation: Namespace.ID
    @Binding var isEditing: Bool
    @State private var showAlert = false
    @State private var imageViewSize: CGSize = .zero
    
    private var imageOffset: CGFloat {
        if editViewModel.selectedAction == .adjustment {
            return -100
        } else {
            return 0
        }
    }
    
    private var displayedImage: UIImage {
        var finalImage = viewModel.currentPhoto.image
        
        if editViewModel.selectedAction == .adjustment, let adjustedImage = adjustmentViewModel.adjustedImage {
            finalImage = adjustedImage
        }
        
        if editViewModel.selectedAction == .filter, let filteredImage = filterViewModel.filteredImage {
            finalImage = filteredImage
        }
        
        if editViewModel.selectedAction == .blur, let blurredImage = blurViewModel.bluredImage {
            finalImage = blurredImage
        }
        
        if editViewModel.selectedAction == .crop, let croppedImage = cropViewModel.croppedImage {
            return croppedImage
        }
        
        return finalImage
    }
    
    
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Image(uiImage: displayedImage)
                        .resizable()
                        .rotationEffect(Angle(degrees: Double(cropViewModel.rotationAngle)))
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        .background(Color.black)
                        .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)
                        .scaleEffect(zoomHandler.currentScale)
                        .offset(y: imageOffset)
                        .onAppear {
                            let imageSize = viewModel.currentPhoto.image.size
                            let viewSize = CGSize(width: geometry.size.width, height: geometry.size.height * 0.65)
                            cropViewModel.initializeCropBox(for: imageSize, in: viewSize)
                            self.imageViewSize = viewSize
                        }
                        .overlay(
                            GeometryReader { geometry in
                                if editViewModel.selectedAction == .crop && cropViewModel.isCropBoxVisible {
                                    CropBox(rect: $cropViewModel.cropRect, minSize: CGSize(width: 100, height: 100))
                                }
                            }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    zoomHandler.magnificationChanged(value)
                                }
                                .onEnded { value in
                                    zoomHandler.magnificationEnded(value)
                                }
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0).onEnded { value in
                                if editViewModel.selectedAction == .blur {
                                    let touchPoint = value.location
                                    let imageFrame = geometry.frame(in: .local)
                                    blurViewModel.applyBlur(at: touchPoint, in: geometry.size, imageFrame: imageFrame)
                                }
                            }
                        )
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 30)
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                EditFullScreenPhotoBottomView(
                    viewModel: editViewModel,
                    filterViewModel: filterViewModel,
                    cropViewModel: cropViewModel,
                    adjustViewModel: adjustmentViewModel,
                    blurViewModel: blurViewModel,
                    cropRect: $cropViewModel.cropRect,
                    imageViewSize: $imageViewSize,
                    rotationAngle: $cropViewModel.rotationAngle
                )
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("편집 취소"),
                        message: Text("변경 사항을 취소하고 원본으로 돌아가시겠습니까?"),
                        primaryButton: .destructive(Text("확인")) {
                            editViewModel.resetEdits()
                            isEditing = false
                            editViewModel.selectedAction = nil
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: Button("취소") {
            showAlert = true
        })
    }
    
    private func centerCropBox(in size: CGSize) {
        let padding: CGFloat = 20
        let width = size.width - padding * 2
        let height = size.height * 0.65 - padding * 2
        
        cropViewModel.cropRect = CGRect(
            x: (size.width - width) / 2,
            y: (size.height * 0.65 - height) / 2,
            width: width,
            height: height
        )
    }
}
