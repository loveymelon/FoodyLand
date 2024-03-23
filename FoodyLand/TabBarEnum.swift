//
//  TabBarEnum.swift
//  FoodyLand
//
//  Created by 김진수 on 3/24/24.
//

import UIKit

enum TabBarEnum: CaseIterable {
    case map
    case setting
    
    var images: UIImage? {
        switch self {
        case .map:
            return UIImage(systemName: "map")
        case .setting:
            return UIImage(systemName: "gearshape")
        }
    }
}
