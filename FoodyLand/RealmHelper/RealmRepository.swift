//
//  RealmRepository.swift
//  FoodyLand
//
//  Created by 김진수 on 3/16/24.
//

import Foundation
import RealmSwift

enum RealmError: Error {
    case createFail
    case updateFail
    case deleteFail
    case noData
    case unknownError
}

typealias RealmResult = Result<Void, RealmError>

class RealmRepository {
    private let realm = try! Realm()
    
    func createItem<T: Object>(item: T) -> RealmResult {
        do {
            try realm.write {
                realm.add(item)
                
                print(realm.configuration.fileURL)
            }
            return .success(())
        } catch {
            return .failure(.createFail)
        }
    } // 카테고리를 만들 수도 있고 유저의 메모를 만들 수 있어서 제네릭으로 처리함, 이미지도 만들어야됨 순서는 카테고리 - 이미지 - 유저 메모 순으로 만들어야됨 유저메모를 만들때는 카테고리 유저 append를 시켜줘야된다.
    
    func createUserDiary(location: Location, categoryItem: Category, detailData: DetailData, marketItem: UserDiary) -> RealmResult {
        
        do {
            try realm.write {
                marketItem.memo = detailData.memo
                marketItem.location = location
                marketItem.category = categoryItem
                
                realm.add(marketItem)
                
                print(realm.configuration.fileURL)
                
            }
            return .success(())
        } catch {
            return .failure(.createFail)
        }
        
    }
    
    func fetchCategoryItem(index: Int) -> Category {
        let item = realm.objects(Category.self)
        let res = item[(item.count - 1) - index]
        
        return res
    }
    
    func fetchItem<T: Object>(type: T.Type) -> Result<Results<T>, RealmError> {
        let items = realm.objects(type.self) // 타입 자체가 필요하므로
        
        return .success(items)
    } // 카테고리를 가져올 수도 있고 유저의 메모들을 가져올 수도 있기 때문에
    
    func updateItem(marketItem: UserDiary, categoryItem: Category, locationData: Location, detailData: DetailData) -> Result<(), RealmError> { // viewModel에서 값 비교후 다른게 있다면
        let items = realm.objects(UserDiary.self) // 업데이트를 할때 몇 번째에 있는 데이터를 업데이트할 지 어떻게 알 수 있을까? 레코드들은 리스트형식으로 있는데 인덱스에 어떻게 접근할지 고민해보자.
        // 마켓의 고유 아이디로 접근할 수 있지 않을까? 이미지를 수정할때도 where문에서 마켓 고유 아이디랑 일치한 테이블을 가져와서 거기에 있는 이미지를 수정하는 것이다.
        
        let item = items.where { item in
            item.marketId == marketItem.marketId
        }
        
        guard let oneItem = item.first else { return .failure(.unknownError) }
        
        do {
            
            try realm.write {
                print(#function)
                oneItem.date = detailData.calender.toDate() ?? Date()
                oneItem.memo = detailData.memo
                oneItem.star = detailData.star
                oneItem.category = categoryItem
                oneItem.date = marketItem.date
                oneItem.location = locationData
            
                print(realm.configuration.fileURL)
            } // 일단 업데이트가 가능한 컬럼들을 모아봤다. -> 바뀌지 않은 컬럼들을 다시 하나씩 넣는 과정이 비효율적이지 않을까?
            return .success(())
        } catch {
            return .failure(.updateFail)
        }
        
    }
    
    func updateImage(marketItem: UserDiary, imageCount: Int) {
        let items = realm.objects(UserDiary.self)
        
        let item = items.where { item in
            item.marketId == marketItem.marketId
        }
        
        do {
            try realm.write {
                for i in 1...imageCount {
                    item.first?.userImages.append(UserImages())
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(marketId: String) -> RealmResult {
        
        let items = realm.objects(UserDiary.self)
        
        let item = items.where { item in
            item.marketId == marketId
        }
        
        do {
            try realm.write {
                realm.delete(item)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
        
    } // 유저 테이블 삭제시 하위 테이블(카테고리, 사진)을 지우고 테이블을 지워야된다.
    // 삭제시에도 유저 사진 = 유저 메모 순으로 지워야된다.
    
    func deleteCategory(index: Int) -> RealmResult {
        let items = realm.objects(Category.self)
        
        do {
            try realm.write { 
                realm.delete(items[(items.count - 1) - index]) // realm과 array의 index가 반대이므로
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
    func checkData(location: Location) -> Results<UserDiary> {
        let predicate = NSPredicate(format: "location.latitude == %lf AND location.longitude == %lf", location.latitude, location.longitude)
        let item = realm.objects(UserDiary.self).filter(predicate)
        
        return item
    }
    
    func fetchImageId(index: Int) -> String {
        let item = realm.objects(UserImages.self)[index]
        
        return item.id.stringValue
    }
    
    func updateImageDatas(marketId: String, imageCount: Int) -> UserDiary {
        let item = realm.objects(UserDiary.self).where { item in
            item.marketId == marketId
        }
        
        do {
            try realm.write {
                for _ in 1...imageCount {
                    item.first?.userImages.append(UserImages())
                }
            }
        } catch {
            print(error)
        }
        
        return item[0]
    }
    
    func deleteImageDatas(id: String) {
        let items = realm.objects(UserImages.self)
        
        do {
            
            let id = try ObjectId(string: id)
            
            try realm.write {
                let item = items.where { item in
                    item.id == id
                }
                
                realm.delete(item)
                
            }
            
        } catch {
            print(error)
        }
    
    }
    
}
