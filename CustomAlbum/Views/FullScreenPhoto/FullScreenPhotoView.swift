//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    /*
     AlbumViewModel은 탭 간 사진 값 변화를 감지하고 처리하기 위해 CustomAlbumApp에 선언하여 활용하도록 구현되었습니다.
     그로인해 추가 다른 view에서 AlbumViewModel에 접근하기 위해 EnviromentObject를 활용하였습니다.
     
     FullScreenPhotoViewModel은 현재 표시되는 사진에 대한 정보, 상태를 관리합니다.
     */
    @EnvironmentObject var albumViewModel: AlbumViewModel
    @ObservedObject var viewModel: FullScreenPhotoViewModel
    @ObservedObject var editViewModel: EditImageViewModel
    @ObservedObject var adjustmentViewModel: EditAdjustmentViewModel
    @ObservedObject var blurViewModel: EditBlurViewModel
    @ObservedObject var filterViewModel: EditFilterViewModel
    @ObservedObject var cropViewModel: EditCropViewModel
    @StateObject private var zoomHandler = PhotoZoomHandler()
    
    @State private var isEditing = false
    @Namespace private var animation
    @Environment(\.presentationMode) var presentationMode
    
    // 현재 표시할 이미지를 결정하는 속성입니다.
    private var displayedImage: UIImage {
        return viewModel.currentPhoto.image
    }
    
    // 사진 회전 각도를 결정하는 계산 속성입니다. 회전 각도는 편집 뷰에서만 적용되고, 여기서는 초기 각도를 사용합니다.
    private var rotationAngle: CGFloat {
        return 0
    }
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    let imageHeight = geometry.size.height * 0.65
                    let topOffset = viewModel.showInfoView ? -geometry.size.height * 0.15 : 0
                    
                    Image(uiImage: displayedImage)
                        .resizable()
                        .rotationEffect(Angle(degrees: Double(rotationAngle)))
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                        .background(Color.black)
                        .matchedGeometryEffect(id: viewModel.currentPhoto.id, in: animation)
                        .scaleEffect(zoomHandler.currentScale)
                        .offset(y: topOffset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    zoomHandler.magnificationChanged(value)
                                }
                                .onEnded { value in
                                    zoomHandler.magnificationEnded(value)
                                }
                        ) // 줌 제스처를 추가해 이미지 확대 및 축소를 제어합니다.
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 20)
                    
                    if viewModel.showInfoView {
                        InfoView(photo: viewModel.currentPhoto)
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.37)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                            .offset(y: imageHeight)
                    } // showInfoView가 toggle되면 infoView를 호출합니다.
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Spacer()
                FullScreenPhotoBottomView(
                    onShare: {
                        viewModel.toggleSharePhoto()
                    },
                    onFavorite: {
                        viewModel.toggleFavorite()
                    },
                    onInfo: {
                        viewModel.toggleInfo()
                    },
                    onDelete: {
                        viewModel.toggleDeletePhoto()
                    },
                    isFavorite: viewModel.currentPhoto.isFavorite
                ) // FullScreenPhotoView 하단 사진공유, 즐겨찾기, 정보, 삭제 기능을 제공하는 뷰 입니다.
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.4), value: isEditing)
            }
            
            if viewModel.showFavoriteAnimation {
                favoriteAnimationView()
            }
            
            if isEditing {
                EditFullScreenPhotoView(
                    viewModel: viewModel,
                    editViewModel: editViewModel,
                    adjustmentViewModel: adjustmentViewModel,
                    blurViewModel: blurViewModel,
                    filterViewModel: filterViewModel,
                    cropViewModel: cropViewModel,
                    animation: animation,
                    isEditing: $isEditing
                )
                .gesture(DragGesture().onChanged { _ in })
            } // 편집 버튼을 눌러 isEditing이 true가 되면 EditFullScreenPhotoView를 호출합니다.
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: isEditing ? nil : editButton)
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                albumViewModel.removePhoto(by: viewModel.currentPhoto.id)
                presentationMode.wrappedValue.dismiss()
            }
        } // shouldDismiss가 true가 되면 현재 화면을 닫고, 사진을 제거합니다.
        .gesture(
            isEditing ? DragGesture().onChanged { _ in } : nil
        )
    }
    
    private var editButton: some View {
        Button(action: {
            if !isEditing {
                withAnimation {
                    isEditing.toggle()
                }
            }
        }) {
            Text("편집")
        }
    }
    
    private func favoriteAnimationView() -> some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(Color(UIColor.systemIndigo))
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.5, dampingFraction: 0.1), value: viewModel.showFavoriteAnimation)
    }
}
