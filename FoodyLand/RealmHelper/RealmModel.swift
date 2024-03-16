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
    
    @Persisted var category: List<Category>
    @Persisted var userImages: List<UserImages>
    
    convenience init(marketId: String, marketName: String, address: String, url: String, star: Double, memo: String, date: Date, location: Location? = nil) {
        self.init()
        
        self.marketId = marketId
        self.marketName = marketName
        self.address = address
        self.url = url
        self.star = star
        self.memo = memo
        self.date = date
        self.location = location
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
    
    @Persisted(originProperty: "category") var parents: LinkingObjects<UserDiary>
    
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
