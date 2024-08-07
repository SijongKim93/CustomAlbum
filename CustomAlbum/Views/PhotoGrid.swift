//
//  PhotoGrid.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI


struct PhotoGrid: View {
    let photos: [Photo]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(photos) { photo in
                    PhotoGridItem(photo: photo)
                }
            }
            .padding()
        }
    }
}

struct PhotoGrid_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGrid(photos: [
            Photo(id: "1", image: UIImage(systemName: "photo")!, date: Date(), location: "Seoul, Korea"),
            Photo(id: "2", image: UIImage(systemName: "photo")!, date: Date(), location: "Tokyo, Japan")
        ])
    }
}
