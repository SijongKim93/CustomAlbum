//
//  CropOptionButton.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct CropOptionButton: View {
    var optionName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: optionName == "우회전" ? "rotate.right" : (optionName == "좌회전" ? "rotate.left" : "aspectratio"))
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                Text(optionName)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}
