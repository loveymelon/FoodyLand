//
//  PageModel.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

struct PageData: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let total: Int
    let sameName: NameData
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case total = "total_count"
        case sameName = "same_name"
    }
}
