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
    let outputUserDiary: Observable<UserDiary> = Observable(UserDiary(marketId: "", marketName: "", address: "", url: "", star: 3.0, memo: "", date: Date(), category: nil))
    let outputLocation: Observable<Location> = Observable(Location())
    let outputError: Observable<FLError> = Observable(.none)
    
    let inputSearchText: Observable<String?> = Observable(nil)
    let inputPage: Observable<Int> = Observable(1)
    let inputSelectedData: Observable<Address> = Observable(Address(addressName: "", addId: "", phone: "", placeName: "", placeURL: "", roadAddress: "", x: "", y: ""))
    
    init() {
        inputSearchText.bind { [weak self] value in
            guard let self else { return }
            guard value != nil else { return }
    
            self.checkValue(text: value)
        }
        
        inputPage.bind { [weak self] page in
            guard let self else { return }
            
            self.checkValue(text: inputSearchText.value, page: inputPage.value)
        }
        
        inputSelectedData.bind { [weak self] result in
            guard let self else { return }
            guard result.addId != "" else { return }
            
            convertData(data: result)
        }
    }
    
    func searchNoData(_ text: String) -> String {
        return text + FLText.searchNoDataText
    }
    
}

extension SearchViewModel {
    private func checkValue(text: String?, page: Int = 1) {
        guard let text = text else { return }
//        self.outputText.value = text.matchString(text: text)
        NetworkAPI.shared.fetchKeyword(type: KeywordModel.self, api: NetworkManager.searchKeyword(text, page, 15)) { [weak self] response in
            
            guard let self else { return }
            
            switch response {
            case .success(let success):
                
                if outputData.value.sameName.keyword != success.meta.sameName.keyword {
                    outputText.value = success.documents
                    inputPage.value = 1
                } else {
                    outputText.value.append(contentsOf: success.documents)
                }
                
                outputData.value = success.meta
            case .failure(let error):
                outputError.value = ErrorHandleManager.shared.errorHandle(error)
            }
        }
    }

    private func convertData(data: Address) {
        outputUserDiary.value = UserDiary(marketId: data.addId, marketName: data.placeName, address: data.addressName, url: data.placeURL, star: 3.0, memo: "", date: Date(), category: nil)
        
        guard let latitude = Double(data.y) else { return }
        guard let longitude = Double(data.x) else { return }
        
        outputLocation.value.latitude = latitude
        outputLocation.value.longitude = longitude
    }
}
