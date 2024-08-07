//
//  PhotoGridItem.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct PhotoGridItem: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                if let date = photo.date {
                    Text(DateFormatter.mediumDateShortTime.string(from: date))
                        .font(.caption)
                }
                if let location = photo.location {
                    Text(location)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PhotoGridItem_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridItem(photo: Photo(id: "1", image: UIImage(systemName: "photo")!, date: Date(), location: "Seoul, Korea"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
