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
    let outputImageId: Observable<[[UserImages]]> = Observable([[UserImages()]])
    
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
        var imageIds: [[UserImages]] = []
        
        switch result {
        case .success(let success):
            
            for (index, item) in success.enumerated() {
                idArr.append(item.id.stringValue)
                imageIds.append(Array(item.userImages))
            }
            
            outputImageId.value = imageIds
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
