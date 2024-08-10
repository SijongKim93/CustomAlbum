//
//  CustomAlbumApp.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import SwiftUI
import SwiftData

@main
struct CustomAlbumApp: App {
    @StateObject private var albumViewModel = AlbumViewModel()
    
    var body: some Scene {
        WindowGroup {
            AlbumTabView()
                .environmentObject(albumViewModel)
        }
    }
}
