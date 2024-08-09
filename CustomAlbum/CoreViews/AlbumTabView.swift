//
//  AlbumTabView.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/9/24.
//

import SwiftUI

struct AlbumTabView: View {
    var body: some View {
        NavigationView {
            TabView {
                AlbumView()
                    .tabItem {
                        Image(systemName: "photo")
                        Text("My Album")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorite")
                    }
                
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumTabView()
    }
}
