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
    let isFavorite: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .clipped()
                .overlay(
                    isSelected ? Color.black.opacity(0.3) : Color.clear
                )
            
            if isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(Color(UIColor.systemIndigo))
                    .padding(6)
            }
        }
    }
}
