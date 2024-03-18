//
//  SearchViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import Foundation

final class SearchViewModel {
    let outputText: Observable<[Address]> = Observable([])
    let outputData: Observable<PageData> = Observable(PageData(isEnd: false, pageableCount: 0, total: 0, sameName: NameData(keyword: "")))
    
    let inputSearchText: Observable<String?> = Observable(nil)
    let inputPage: Observable<Int> = Observable(1)
    
    init() {
        inputSearchText.bind { [weak self] value in
            guard let self = self else { return }
            guard value != nil else { return }
    
            self.checkValue(text: value)
        }
        
        inputPage.bind { [weak self] page in
            guard let self = self else { return }
            
            self.checkValue(text: self.inputSearchText.value, page: self.inputPage.value)
        }
    }
    
    private func checkValue(text: String?, page: Int = 1) {
        guard let text = text else { return }
//        self.outputText.value = text.matchString(text: text)
        NetworkAPI.shared.fetchKeyword(type: KeywordModel.self, api: NetworkManager.searchKeyword(text, page, 15)) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(let success):
                
                if outputData.value.sameName.keyword != success.meta.sameName.keyword {
                    outputText.value = success.documents
                    inputPage.value = 1
                } else {
                    outputText.value.append(contentsOf: success.documents)
                }
                
                outputData.value = success.meta
            case .failure(let failure):
                print(failure)
            }
        }
    }


    
}
