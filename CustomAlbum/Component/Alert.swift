//
//  Alert.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/13/24.
//

import SwiftUI

struct AlertComponent: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String

    var body: some View {
        EmptyView()
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    dismissButton: .default(Text("확인"))
                )
            }
    }
}

