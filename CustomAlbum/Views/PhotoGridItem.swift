//
//  PhotoGridItem.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct PhotoGridItem: View {
    let photo: Photo
    let isSelected: Bool
    
    var body: some View {
        Image(uiImage: photo.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
            .clipped()
            .opacity(isSelected ? 0 : 1)
    }
}

//struct PhotoGridItem_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoGridItem(photo: Photo(id: "1", image: UIImage(systemName: "photo")!, date: Date(), location: "Seoul, Korea"))
//            .frame(width: 100, height: 100)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
