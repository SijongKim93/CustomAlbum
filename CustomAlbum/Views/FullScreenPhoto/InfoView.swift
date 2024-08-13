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
            Text("정보")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
            
            if let date = photo.date {
                Text("날짜 : \(DateFormatter.mediumDateShortTime.string(from: date))")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            
            if let location = photo.location {
                Text("위치 : \(location)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black)
        .padding()
    }
}
