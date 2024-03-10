//
//  String+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import Foundation

extension String {
    func matchString (text: String) -> String {
        
        let pattern = "[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]" // 한글, 영어, 숫자만 허용
        
        let result = text.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        
        return result
    }
}
