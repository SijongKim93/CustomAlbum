//
//  CropOptionButton.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/11/24.
//

import SwiftUI

struct CropOptionButton: View {
    let optionName: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                Text(optionName)
                    .font(.caption)
            }
        }
    }
}

