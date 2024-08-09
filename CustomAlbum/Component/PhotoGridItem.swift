//
//  PhotoGridItem.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct PhotoGridItem: View {
    let photo: UIImage
    let isSelected: Bool
    
    var body: some View {
        Image(uiImage: photo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(
                isSelected ? Color.black.opacity(0.3) : Color.clear
            )
    }
}
