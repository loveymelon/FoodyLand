//
//  CategoryViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    var str = ["새 컬렉션", "전체"] // repository로 fetch시 여기에 append됨
    
    let outputCategoryData: Observable<[String]> = Observable([])
    let outputError: Observable<RealmError> = Observable(.unknownError)
    
    let inputCategoryData: Observable<String> = Observable("")
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputDeleteTrigger: Observable<Void?> = Observable(nil)
    
    var selectData = ""
    let repository = RealmRepository()
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            fetchCategoryDatas()
        }
        
        inputCategoryData.bind { [weak self] text in
            guard let self else { return }
            guard !text.isEmpty else { return } // text가 비워있을때 insert되는것을 막는다.
            
            insertCategoryData(text: text)
        }
        
        inputDeleteTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            guard !selectData.isEmpty else { return }
            
            deleteCategoryData(text: selectData)
        }
    }
    
    private func fetchCategoryDatas() {
        let data = repository.fetchItem(type: Category.self)
        let sortedData = data.sorted(byKeyPath: "regDate", ascending: false) // 추가한 최신별로 바꿔준다.
        var tempData: [String] = []
        
        for item in sortedData {
            tempData.append(item.categoryName)
        }
        
        outputCategoryData.value = tempData
    }
    
    private func insertCategoryData(text: String) {
        
        let data = Category(categoryName: text, regDate: Date())
        
        switch repository.createItem(item: data) {
        case .success(_):
            
            let categoryDatas = repository.fetchItem(type: Category.self)
            let sortedData = categoryDatas.sorted(byKeyPath: "regDate", ascending: false)
            
            outputCategoryData.value.insert(sortedData[0].categoryName, at: 0) // 테이블이 업데이트 되었으니 뷰에도 업데이트 하게 해준다.
            
        case .failure(let failure):
            outputError.value = failure
        }
        
    }
    
    private func deleteCategoryData(text: String) {
        
        switch repository.deleteCategory(text: text) {
        case .success(_):
            print("success")
            fetchCategoryDatas() // 삭제했으니 뷰에도 업데이트하기 위해서
        case .failure(let failure):
            outputError.value = failure
        }
        
    }
    
}
