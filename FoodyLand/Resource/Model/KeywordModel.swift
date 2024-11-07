//
//  KeywordModel.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

struct KeywordModel: Decodable {
    let documents: [Address]
    let meta: PageData
}
