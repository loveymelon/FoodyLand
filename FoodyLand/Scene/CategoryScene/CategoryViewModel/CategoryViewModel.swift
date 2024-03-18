//
//  CategoryViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    let outputCategoryData: Observable<[CategoryData]?> = Observable(nil)
    let outputError: Observable<RealmError> = Observable(.unknownError)
    
    let inputCategoryData: Observable<String> = Observable("")
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputDeleteTrigger: Observable<Void?> = Observable(nil)
    
    var selectData = ""
    var selectIndex: Int? = nil
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
            guard let num = selectIndex else { return }
            
            deleteCategoryData(index: num)
        }
    }
    
    private func fetchCategoryDatas() {
        let data = repository.fetchItem(type: Category.self)
        
        print(data)
        
        switch data {
        case .success(let success):
            
            let sortedData = success.sorted(byKeyPath: "regDate", ascending: false) // 추가한 최신별로 바꿔준다.
            
            var tempData: [CategoryData] = []
            
            for item in sortedData {
                tempData.append(CategoryData(category: item.categoryName))
            }
            
            outputCategoryData.value = tempData
            
        case .failure(let failure):
            outputError.value = failure
        }
        
        
    }
    
    private func insertCategoryData(text: String) {
        
        let data = Category(categoryName: text, regDate: Date())
        
        switch repository.createItem(item: data) {
        case .success(_):
            
            let categoryDatas = repository.fetchItem(type: Category.self)
            
            switch categoryDatas {
                
            case .success(let success):
                
                let sortedData = success.sorted(byKeyPath: "regDate", ascending: false)
                outputCategoryData.value?.insert(CategoryData(category: sortedData[0].categoryName), at: 0) // 테이블이 업데이트 되었으니 뷰에도 업데이트 하게 해준다.
                
            case .failure(let failure):
                outputError.value = failure
            }
            
            
        case .failure(let failure):
            outputError.value = failure
        }
        
    }
    
    private func deleteCategoryData(index: Int) {
        
        switch repository.deleteCategory(index: index) {
        case .success(_):
            print("success")
            fetchCategoryDatas() // 삭제했으니 뷰에도 업데이트하기 위해서
            selectIndex = nil
        case .failure(let failure):
            outputError.value = failure
        }
        
    }
    
}
