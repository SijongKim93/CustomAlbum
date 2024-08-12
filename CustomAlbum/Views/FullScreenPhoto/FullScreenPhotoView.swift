//
//  FullScreenPhotoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/8/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
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
        
        if editViewModel.selectedAction == .crop, cropViewModel.cropApplied {
            finalImage = cropViewModel.applyActionCrop(with: cropViewModel.cropRect, imageViewSize: CGSize.zero, to: finalImage) ?? finalImage
        }
        
        return finalImage
    }
    
    private var rotationAngle: CGFloat {
        return cropViewModel.rotationAngle
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
                        )
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 20)
                    
                    if viewModel.showInfoView {
                        InfoView(photo: viewModel.currentPhoto)
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.37)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.4), value: viewModel.showInfoView)
                            .offset(y: imageHeight)
                    }
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
                )
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
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: isEditing ? nil : editButton)
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                albumViewModel.removePhoto(by: viewModel.currentPhoto.id)
                presentationMode.wrappedValue.dismiss()
            }
        }
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
