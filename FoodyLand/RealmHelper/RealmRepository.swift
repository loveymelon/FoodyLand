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
    
    func fetchItem<T: Object>(type: T.Type) -> Result<Results<T>, RealmError> {
        let items = realm.objects(type.self) // 타입 자체가 필요하므로
        
        return .success(items)
    } // 카테고리를 가져올 수도 있고 유저의 메모들을 가져올 수도 있기 때문에
    
    func updateItem(marketId: String, marketItem: UserDiary) -> RealmResult { // viewModel에서 값 비교후 다른게 있다면
        let items = realm.objects(UserDiary.self) // 업데이트를 할때 몇 번째에 있는 데이터를 업데이트할 지 어떻게 알 수 있을까? 레코드들은 리스트형식으로 있는데 인덱스에 어떻게 접근할지 고민해보자.
        // 마켓의 고유 아이디로 접근할 수 있지 않을까? 이미지를 수정할때도 where문에서 마켓 고유 아이디랑 일치한 테이블을 가져와서 거기에 있는 이미지를 수정하는 것이다.
        
        let item = items.where { item in
            item.marketId == marketId
        }
        
        guard let oneItem = item.first else { return .failure(.unknownError) }
        
        do {
            
            try realm.write {
                oneItem.category = marketItem.category
                oneItem.date = marketItem.date
                oneItem.memo = marketItem.memo
                oneItem.star = marketItem.star
                
                oneItem.category = marketItem.category
                oneItem.date = marketItem.date
                
//                oneItem.
                
                realm.add(oneItem)
            } // 일단 업데이트가 가능한 컬럼들을 모아봤다. -> 바뀌지 않은 컬럼들을 다시 하나씩 넣는 과정이 비효율적이지 않을까?
            return .success(())
        } catch {
            return .failure(.updateFail)
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
    
    func deleteCategory(text: String) -> RealmResult {
        let items = realm.objects(Category.self)
        
        let item = items.where { item in
            item.categoryName == text
        }
        
        do {
            try realm.write {
                realm.delete(item)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
}
