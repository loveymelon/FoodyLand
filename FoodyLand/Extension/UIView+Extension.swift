//
//  UIView+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/8/24.
//

import UIKit

extension UIView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
