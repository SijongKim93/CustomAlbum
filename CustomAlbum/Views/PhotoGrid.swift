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
    @Binding var selectedPhoto: Photo?
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(photos) { photo in
                    PhotoGridItem(photo: photo, isSelected: selectedPhoto?.id == photo.id)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedPhoto = photo
                            }
                        }
                        .matchedGeometryEffect(id: photo.id, in: animation)
                }
            }
        }
        .background(Color.primary.colorInvert())
    }
}


//struct PhotoGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoGrid(photos: [
//            Photo(id: "1", image: UIImage(systemName: "photo")!, date: Date(), location: "Seoul, Korea"),
//            Photo(id: "2", image: UIImage(systemName: "photo")!, date: Date(), location: "Tokyo, Japan"),
//            Photo(id: "3", image: UIImage(systemName: "photo")!, date: Date(), location: "New York, USA"),
//            Photo(id: "4", image: UIImage(systemName: "photo")!, date: Date(), location: "London, UK"),
//            Photo(id: "5", image: UIImage(systemName: "photo")!, date: Date(), location: "Paris, France"),
//            Photo(id: "6", image: UIImage(systemName: "photo")!, date: Date(), location: "Rome, Italy")
//        ])
//        .frame(height: 400)
//    }
//}
