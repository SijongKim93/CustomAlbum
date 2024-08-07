//
//  DateFormatter.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/7/24.
//

import Foundation

extension DateFormatter {
    static let mediumDateShortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
