//
//  SettingEnum.swift
//  FoodyLand
//
//  Created by 김진수 on 3/24/24.
//

import Foundation

enum SettingEnum: CaseIterable {
    case notice
    case qa
    case help
    case reset
    
    var title: String {
        switch self {
        case .notice:
            return "Notice"
        case .qa:
            return "Q&A"
        case .help:
            return "Help"
        case .reset:
            return "Reset Data"
        }
    }
}
