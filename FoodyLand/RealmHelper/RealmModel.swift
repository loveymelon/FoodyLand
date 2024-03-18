//
//  RealmModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/16/24.
//

import RealmSwift
import Foundation

class UserDiary: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var marketId: String
    @Persisted var marketName: String
    @Persisted var address: String
    @Persisted var url: String
    @Persisted var star: Double
    @Persisted var memo: String
    @Persisted var date: Date
    
    @Persisted var location: Location?
    
    @Persisted var category: Category? // 한 명의 사용자가 하나의 카테고리만 가질 수 있다. 1 : 1
    @Persisted var userImages: List<UserImages> // 한 명의 사용자가 여러개의 사진을 가질 수 있다.
    
    convenience init(marketId: String, marketName: String, address: String, url: String, star: Double, memo: String, date: Date, category: Category?) {
        self.init()
        
        self.marketId = marketId
        self.marketName = marketName
        self.address = address
        self.url = url
        self.star = star
        self.memo = memo
        self.date = date
        self.category = category
    }
}

class UserImages: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted(originProperty: "userImages") var parents: LinkingObjects<UserDiary>
}

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var categoryName: String
    @Persisted var regDate: Date
    
    @Persisted var diarys: List<UserDiary> // 하나의 카테고리가 여러명의 유저를 가질 수 있으므로 1 : N
    
    convenience init(categoryName: String, regDate: Date) {
        self.init()
        
        self.categoryName = categoryName
        self.regDate = regDate
    }
}

class Location: EmbeddedObject {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
}
