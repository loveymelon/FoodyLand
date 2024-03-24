//
//  FoodyMapViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation

class FoodyMapViewModel {
    let outputLocationValue: Observable<[Location]> = Observable([])
    let outputDetailData: Observable<UserDiary> = Observable(UserDiary(marketId: "", marketName: "", address: "", url: "", star: 3, memo: "", date: Date(), category: nil))
    let outputRemoveAll: Observable<Bool> = Observable(false)
    
    let inputLocationValue: Observable<Location?> = Observable(nil)
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputTappedAnnoTrigger: Observable<Location?> = Observable(nil)
    
    let repository = RealmRepository()
    
    init() {
        inputLocationValue.bind { [weak self] result in
            guard let self else { return }
            guard let value = result else { return }
            
            self.converValue(data: value)
        }
        
        inputViewDidLoadTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            fetchLocationData()
        }
        
        inputTappedAnnoTrigger.bind { [weak self] result in
            guard let self else { return }
            guard let location = result else { return }
            
            fetchUserDiary(location: location)
        }
    }
    
    private func converValue(data: Location) {
        print(#function)
        outputLocationValue.value = [data]
    }
    
    private func fetchLocationData() {
        print(#function)
        let locations = repository.fetchLocationValue()
        
        outputLocationValue.value = locations
    }
    
    private func fetchUserDiary(location: Location) {
        outputDetailData.value = repository.checkData(location: location)[0]
    }
    
}
