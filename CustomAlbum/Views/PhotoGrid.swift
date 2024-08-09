//
//  PhotoGrid.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI


struct PhotoGrid: View {
    let photos: [Photo]
    let columns: [GridItem]
    @Binding var selectedPhotoIndex: Int?
    var animation: Namespace.ID
    var onScrolledToEnd: (Photo) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(photos.indices, id: \.self) { index in
                    PhotoGridItem(photo: photos[index], isSelected: selectedPhotoIndex == index)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedPhotoIndex = index
                            }
                        }
                        .matchedGeometryEffect(id: photos[index].id, in: animation)
                        .onAppear {
                            onScrolledToEnd(photos[index])
                        }
                }
            }
        }
        .background(Color.primary.colorInvert())
    }
}

