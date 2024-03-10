//
//  UISearchBar+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import UIKit

extension UISearchBar {
    func setTextFieldBackground(color: UIColor, transparentBackground: Bool = true) {
        if transparentBackground {
            // 서치바의 전체 배경을 투명하게 설정
            self.backgroundImage = UIImage()
        }
        // 서치바 내부의 UITextField를 찾아서 배경색을 설정
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = color
        }
    }
}
