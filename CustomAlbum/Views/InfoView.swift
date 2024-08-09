//
//  InfoView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct InfoView: View {
    var photo: Photo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("사진 정보")
                .font(.title)
                .padding(.bottom, 10)
            
            if let date = photo.date {
                Text("날짜: \(DateFormatter.mediumDateShortTime.string(from: date))")
                    .padding(.bottom, 5)
            }
            
            if let location = photo.location {
                Text("위치: \(location)")
                    .padding(.bottom, 5)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
