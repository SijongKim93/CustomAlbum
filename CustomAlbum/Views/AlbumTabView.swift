//
//  AlbumTabView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct AlbumTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                AlbumView(tabSelection: $selectedTab)
                    .tabItem {
                        Image(systemName: "photo")
                        Text("My Album")
                    }
                    .tag(0)
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorite")
                    }
                    .tag(1)
                
                CameraView()
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Camera")
                    }
                    .tag(2)
            }
            .accentColor(Color(UIColor.systemIndigo))
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumTabView()
    }
}
