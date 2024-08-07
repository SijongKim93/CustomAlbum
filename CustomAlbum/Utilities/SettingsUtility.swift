//
//  SettingsUtility.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import UIKit

enum SettingsUtility {
    static func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        // 설정 없을때 예외처리하기
        UIApplication.shared.open(settingsURL)
    }
}
