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
    
    let outputImageEmptyBool: Observable<Bool> = Observable(false) // 이미지가 비워있는지 확인
    let outputImageCount: Observable<Int> = Observable(0) // 이미지 선택 가능수
    let outputImageOverBool: Observable<Bool> = Observable(false) // 이미지 한도 수 여부
    let outputImageExistBool: Observable<Bool> = Observable(false) // 이미지가 수가 동일하면 파일까지 삭제
    
    let inputRemoveIndex: Observable<Int?> = Observable(nil)
    let inputSaveImageCount: Observable<Int?> = Observable(nil)
    let inputUserImageCount: Observable<Int?> = Observable(nil) // 현재 이미지 수
    let inputImageRemoveId: Observable<[String]> = Observable([]) // 삭제될 이미지의 아이디
    let inputDeleteImageTrigger: Observable<Void?> = Observable(nil) // realm image data 삭제 타이밍 제공
    
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSaveButtonTrigger: Observable<Void?> = Observable(nil)
    let inputCalendarData: Observable<Date?> = Observable(nil)
    let inputLocation: Observable<Location> = Observable(Location())
    
    var detailData: DetailData = DetailData(memo: "", star: 0, calender: "", category: "")
    
    private let repository = RealmRepository()
    var selectedIndex: Int? = nil
    var imageRemoveId: [String] = []
    
    init() {
        inputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard let date = result else { return }
            
            convertCalendarData(date: date)
        }
        
        inputViewDidLoadTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            checkData(diaryData: outputDetailData.value)
        }
        
        inputSaveButtonTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            saveDetailData(data: detailData)
        }
        
        inputUserImageCount.bind { [weak self] result in
            guard let self else { return }
            guard let num = result else { return }
            
            checkImageCount(count: num)
        }
        
        inputRemoveIndex.bind { [weak self] result in
            guard let self else { return }
            guard let index = result else { return }
            
            saveRemoveImageId(index: index)
        }
        
        inputSaveImageCount.bind { [weak self] result in
            guard let self else { return }
            guard let count = result else { return }
            
            saveImages(index: count)
        }
        
        inputImageRemoveId.bind { [weak self] result in
            guard let self else { return }
            guard !result.isEmpty else { return }
            
            checkRealmImageData(count: result.count)
        }
        
        inputDeleteImageTrigger.bind { [weak self] result in
            guard let self else { return }
            guard result != nil else { return }
            
            deleteImageDatas()
        }
        
    }
    
    private func convertCalendarData(date: Date) {
        outputCalendarData.value = date.toString()
        print(outputCalendarData.value, date)
    }
    
    private func checkData(diaryData: UserDiary) {
        
//        print(inputLocation.value)
        
        let data = repository.checkData(location: inputLocation.value)
        
        if !data.isEmpty {
            guard let res = data.first else { return }
            
            outputDetailData.value = res
        }
        
        print(outputDetailData.value)
        
    } // Realm에 값이 있는지 확인
    
    private func saveDetailData(data: DetailData) {
        let realmData = outputDetailData.value
        
        guard let index = selectedIndex else { return }
        
        let categoryData = repository.fetchCategoryItem(index: index)
        
        let location = inputLocation.value
        
        guard let date = data.calender.toDate() else { return }
        
        print(#function)
        // realm에 좌표를 가진 레코드가 있다면 업데이트, 아니면 생성
        if !repository.checkData(location: location).isEmpty {
            
            let res = repository.updateItem(marketItem: realmData, categoryItem: categoryData, locationData: location, detailData: data)
            
            switch res {
                
            case .success(_):
                print("success")
            case .failure(let failure):
                print(failure)
            }
            
        } else {
            let realmData = outputDetailData.value
            
            let categoryData = repository.fetchCategoryItem(index: index)
            
            let res = repository.createUserDiary(location: inputLocation.value, categoryItem: categoryData, detailData: data, marketItem: realmData)
            switch res {
                
            case .success(_):
                print("success")
            case .failure(let failure):
                print(failure)
            }
            
        }
        
    }
    
    private func checkImageCount(count: Int) {
        outputImageEmptyBool.value = count != 0 ? true : false
        outputImageCount.value = 3 - count
        outputImageOverBool.value = count == 3 ? true : false
    }
    
    private func saveRemoveImageId(index: Int) {
        
        imageRemoveId.append(outputDetailData.value.userImages[index].id.stringValue)
    }
    
    private func saveImages(index: Int) {
        outputDetailData.value = repository.updateImageDatas(marketId: outputDetailData.value.marketId, imageCount: index)
    }
    
    private func checkRealmImageData(count: Int) {
        imageRemoveId
        outputImageExistBool.value = count == 3 ? true : false
    }
    
    private func deleteImageDatas() {
        
        for item in imageRemoveId {
            repository.deleteImageDatas(id: item)
        }
        
        let beforeImageCount = outputDetailData.value.userImages.count - imageRemoveId.count
        guard let num = inputUserImageCount.value else { return }
        
        saveImages(index: num - beforeImageCount )
        
    }
}
