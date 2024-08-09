//
//  PhotoZoomHandler.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/10/24.
//

import Foundation


class PhotoZoomHandler: ObservableObject {
    @Published var currentScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    
    func magnificationChanged(_ value: CGFloat) {
        currentScale = lastScale * value
    }
    
    func magnificationEnded(_ value: CGFloat) {
        resetZoom()
    }
    
    func resetZoom() {
        currentScale = 1.0
        lastScale = 1.0
    }
}
