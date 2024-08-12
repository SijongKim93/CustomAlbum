//
//  DeniedView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI

struct DeniedView: View {
    let requestPermission: () -> Void
    
    var body: some View {
        VStack(alignment:.center, spacing: 20) {
            Text("사진첩 접근이 거부되어 \n사진을 가져올 수 없습니다🥲")
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("권한 허용하기 🔓") {
                SettingsUtility.openSettings()
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
    }
}


struct DeniedView_Previews: PreviewProvider {
    static var previews: some View {
        DeniedView(requestPermission: {})
    }
}
