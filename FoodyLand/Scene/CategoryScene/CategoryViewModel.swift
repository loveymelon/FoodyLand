//
//  CategoryViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation

struct CategoryData: Hashable {
    let text: String
    let id = UUID()
}

class CategoryViewModel {
    var str = ["새 컬렉션", "전체"] // repository로 fetch시 여기에 append됨
    
    var arr2: Observable<[CategoryData]> = Observable([CategoryData(text: "aaa"), CategoryData(text: "aaa")])
    
}
