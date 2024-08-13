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
        UIApplication.shared.open(settingsURL)
    }
}
