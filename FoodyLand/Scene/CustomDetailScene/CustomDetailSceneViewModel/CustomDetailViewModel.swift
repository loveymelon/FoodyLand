//
//  CustomDetailViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/12/24.
//

import Foundation

struct DetailData {
    let memo: String
    let star: Double
    let calender: String
    let category: String
}

class CustomDetailViewModel {
    
    let outputCalendarData: Observable<String> = Observable("")
    let outputDetailData: Observable<UserDiary> = Observable(UserDiary(marketId: "", marketName: "", address: "", url: "", star: 0, memo: "", date: Date(), category: Category(categoryName: "", regDate: Date())))
    let outputImageCountRes: Observable<Bool> = Observable(false)
    let outputImageCount: Observable<Int> = Observable(0)
    
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSaveButtonTrigger: Observable<Void?> = Observable(nil)
    let inputCalendarData: Observable<Date?> = Observable(nil)
    
    let inputImageData: Observable<Int?> = Observable(nil) // 하나만 사용해도 되는지 확인
    let inputImageCount: Observable<Int?> = Observable(nil)
    let inputDetailData: Observable<DetailData> = Observable(DetailData(memo: "", star: 0, calender: "", category: ""))
    
    var inputSearchData = Address(addressName: "", addId: "", phone: "", placeName: "", placeURL: "", roadAddress: "", x: "", y: "")
    
    private let repository = RealmRepository()
    var selectedIndex: Int? = nil
    
    init() {
        inputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard let date = result else { return }
            
            convertCalendarData(date: date)
        }
        
        inputViewDidLoadTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            checkData(searchData: inputSearchData)
        }
        
        inputSaveButtonTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            saveData()
        }
        
//        inputImageData.bind { [weak self] result in
//            guard let self else { return }
//            guard let num = result else { return }
//            
//            createImageData(count: num)
//        }
        
        inputImageCount.bind { [weak self] result in
            guard let self else { return }
            guard let num = result else { return }
            
            checkImageCount(count: num)
        }
        
        inputDetailData.bind { [weak self] result in
            guard let self else { return }
            guard result.star != 0.0 else { return }
            
            saveDetailData(data: result)
        }
        
    }
    
    private func convertCalendarData(date: Date) {
        outputCalendarData.value = date.toString()
        print(outputCalendarData.value, date)
    }
    
    private func checkData(searchData: Address) {
        
        let diaryData = repository.fetchItem(type: UserDiary.self)
        
        
        switch diaryData {
        case .success(let diary):
            if repository.checkData(id: searchData.addId) { // 두 번 연산한다는 단점 때문에 나중에 수정해야됨
                
                for item in diary {
                    
                    if item.marketId == outputDetailData.value.marketId {
                        outputDetailData.value = item
                        break
                    } // realm에 값이 있다면
                    
                }
                
            } else {
                
                guard let latitude = Double(searchData.y) else { return }
                guard let longitude = Double(searchData.x) else { return }
                
                
                outputDetailData.value = UserDiary(marketId: searchData.addId, marketName: searchData.placeName, address: searchData.addressName, url: searchData.placeURL, star: 3.0, memo: "", date: Date(), category: Category(categoryName: "", regDate: Date()))
                
            } // realm에 값이 없다면
            
        case .failure(let failure):
            print(failure)
        }
    }
    
    private func saveData() {
        if repository.checkData(id: outputDetailData.value.marketId) {
            
        } else {
            repository.createItem(item: outputDetailData.value)
        }
    }
    
//    private func createImageData(count: Int) {
//        for _ in 1...count {
//            let imageData = repository.createItem(item: UserImages())
//        }
//    }
    
    private func checkImageCount(count: Int) {
        outputImageCountRes.value = count == 3 ? true : false
        outputImageCount.value = 3 - count
    }
    
    private func saveDetailData(data: DetailData) {
        let realmData = outputDetailData.value
        
        guard let index = selectedIndex else { return }
        
        let categoryData = repository.fetchCategoryItem(index: index)
        
        
        let location = Location()
//        guard let latitude = Double(inputSearchData.y) else { return }
//        guard let longitude = Double(inputSearchData.x) else { return }
        
        location.latitude = 0.0
        location.longitude = 0.0
        
        guard let date = data.calender.toDate() else { return }
        
        print(#function)
        if repository.checkData(id: outputDetailData.value.marketId) {
            print("fdmflsd")
            let res = repository.updateItem(marketItem: realmData, categoryItem: categoryData, locationData: location, detailData: data)
        } else {
            print("aaaa")
            let res = repository.createItem(item: realmData)
            print(res)
        }
        
    }
    
}
