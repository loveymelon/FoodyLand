//
//  RealmModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/16/24.
//

import RealmSwift
import Foundation

// 파일 매니저 이용
// 만약 유저 다이어리에서 이미지 아이디가 없다면 파일내부 요소 확인 하지 않고 바로 생성 그게 아니라면 파일안의 이미지 수정 로직으로
// 파일안의 이미지를 수정시 어떻게 내부 요소랑 배열안의 요소랑 다른지 비교후 파일 내 다른 요소만 삭제 후 다시 넣을 수 있을까?
// 일단 테이블에 저장된 아이디들을 비교해봐야될까?
// 메모 테이블의 값이 nil일때는 그냥 저장
// 저장을 하면 아이디가 생긴다. 그냥 저장할때마다 파일 매니저를 이용해서 삭제를 하고 다시 넣을까?
// 테이블 아이디 조건: 3개를 넘으면 안된다
// 파일안의 이미지 이름은 이미지 테이블의 아이디.jpg이다.
// 근데 같은 이미지를 또 넣을 수 있지 않을까?

// 수정로직으로 갈지 말지는 이미지 테이블이 비워있냐 아니냐로 판단한다. 수정시 저장을 누르기전에 삭제를 시켜 삭제되는 아이디를 임시 변수에 담은 후 유저가 저장 버튼을 누르면 해당 아이디를 파일 매니저를 통해서 삭제, 테이블에서도 해당 아이디 삭제 / 삭제되는 만큼 이미지 테이블의 레코드 추가후 파일 매니저에 추가

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
