//
//  SettingViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/24/24.
//

import Foundation
import RealmSwift

class SettingViewModel {
    
    let outputDetailDatas: Observable<[String]> = Observable([])
    
    let inputDeleteTrigger: Observable<Void?> = Observable(nil)
    let inputDeleteAllTrigger: Observable<Void?> = Observable(nil)
    
    private let repository = RealmRepository()
    
    init() {
        inputDeleteTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            fetchUserDiary()
        }
        
        inputDeleteAllTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            deleteAll()
        }
    }
    
    private func fetchUserDiary() {
        let result = repository.fetchItem(type: UserDiary.self)
        var idArr: [String] = []
        
        switch result {
        case .success(let success):
            
            for item in success {
                idArr.append(item.id.stringValue)
            }
            
            outputDetailDatas.value = idArr
            
        case .failure(let failure):
            print(failure)
        }
    }
    
    private func deleteAll() {
        let result = repository.deleteAll()
        
        switch result {
        case .success(_):
            print("success")
        case .failure(let failure):
            print(failure)
        }
    }
    
}
