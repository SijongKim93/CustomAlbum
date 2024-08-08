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
                }
            }
        }
        .background(Color.primary.colorInvert())
    }
}


//struct PhotoGrid_Previews: PreviewProvider {
//    @State static var selectedPhoto: Photo? = nil
//    @Namespace static var animation
//    
//    static var previews: some View {
//        PhotoGrid(
//            photos: [
//                Photo(id: "1", image: UIImage(systemName: "photo")!, date: Date(), location: "Seoul, Korea"),
//                Photo(id: "2", image: UIImage(systemName: "photo")!, date: Date(), location: "Tokyo, Japan"),
//                Photo(id: "3", image: UIImage(systemName: "photo")!, date: Date(), location: "New York, USA"),
//                Photo(id: "4", image: UIImage(systemName: "photo")!, date: Date(), location: "London, UK"),
//                Photo(id: "5", image: UIImage(systemName: "photo")!, date: Date(), location: "Paris, France"),
//                Photo(id: "6", image: UIImage(systemName: "photo")!, date: Date(), location: "Rome, Italy")
//            ],
//            columns: [
//                GridItem(.flexible(), spacing: 1),
//                GridItem(.flexible(), spacing: 1),
//                GridItem(.flexible(), spacing: 1)
//            ],
//            selectedPhoto: $selectedPhoto,
//            animation: animation
//        )
//        .frame(height: 400)
//    }
//}
