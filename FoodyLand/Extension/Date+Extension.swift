//
//  Date+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/13/24.
//

import Foundation

extension Date { 
    func toString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .long
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}

