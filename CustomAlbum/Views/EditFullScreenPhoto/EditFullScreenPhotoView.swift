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
    @Binding var isEditing: Bool // 편집 상태를 추적합니다.
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var albumViewModel: AlbumViewModel
    
    @State private var showAlert = false
    @State private var showSaveAlert = false
    @State private var imageViewSize: CGSize = .zero
    @State private var isSaving = false
    @State private var showSaveErrorAlert = false
    
    // 이미지가 편집 상태로 들어가 adjustment를 선택하면 이미지를 위로 이동되도록 설정했습니다.
    private var imageOffset: CGFloat {
        if editViewModel.selectedAction == .adjustment {
            return -80
        } else {
            return 0
        }
    }
    
    /*
     현재 표시되는 이미지를 계산 속성을 통해 구현하였습니다.
     각 이미지 편집 효과 적용 시 적용 과정에서 충돌 현상이 발생하여
     충돌 되지 않도록 편집 상태에 따라 최종 이미지를 반환합니다.
    */
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
                            Group {
                                if editViewModel.selectedAction == .crop && cropViewModel.isCropBoxVisible {
                                    CropBox(rect: $cropViewModel.cropRect, minSize: CGSize(width: 100, height: 100))
                                }
                            }
                        ) // 크롭 박스를 표시하는 오버레이 입니다.
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    zoomHandler.magnificationChanged(value)
                                }
                                .onEnded { value in
                                    zoomHandler.magnificationEnded(value)
                                }
                        ) // 이미지 확대/축소를 위한 제스처를 추가했습니다.
                        .gesture(
                            DragGesture(minimumDistance: 0).onEnded { value in
                                if editViewModel.selectedAction == .blur {
                                    let touchPoint = value.location
                                    let imageFrame = geometry.frame(in: .local)
                                    blurViewModel.applyBlur(at: touchPoint, in: geometry.size, imageFrame: imageFrame)
                                }
                            }
                        ) // 블러 표과를 적용하기 위한 터치 제스처를 추가했습니다.
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
                ) // 편집 상태의 EditFullScreenPhotoView 하단에 편집 액션을 담당할 버튼을 가지고 있는 View를 넣었습니다.
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("편집 취소"),
                        message: Text("변경 사항을 취소하고 원본으로 돌아가시겠습니까?"),
                        primaryButton: .destructive(Text("확인")) {
                            editViewModel.resetEdits()
                            isEditing = false
                            editViewModel.selectedAction = nil
                        }, // isEditing 상태에서 취소를 누르면 현재 변경된 값을 초기화해 원본 이미지로 돌아오도록 구현했습니다.
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarItems(
            trailing: HStack(spacing: 25) {
                Button("취소") {
                    showAlert = true
                }
                Button("저장") {
                    saveEditedImage()
                }
            }
        )
    }
    
    // 편집된 이미지를 저장하는 로직입니다.
    private func saveEditedImage() {
        isSaving = true
        
        editViewModel.saveEditedImage(editedImage: displayedImage) { success in
            isSaving = false
            if success {
                if let index = albumViewModel.photos.firstIndex(where: { $0.id == viewModel.currentPhoto.id }) {
                    albumViewModel.photos[index].image = displayedImage
                } // 앨범 뷰 모델 사진 리스트를 업데이트 합니다.
                
                isEditing = false
                presentationMode.wrappedValue.dismiss()
            } else {
                showSaveErrorAlert = true
            }
        }
    }
    
    // 크롭 박스를 처음 자르기 옵션 누를 시 중앙에 배치될 수 있도록 구현한 메서드 입니다.
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
