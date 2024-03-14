//
//  CustomDetailViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/12/24.
//

import Foundation

class CustomDetailViewModel {
    
    let outputCalendarData: Observable<String> = Observable("")
    let inoutputDetailData: Observable<Address> = Observable(Address(addressName: "", addId: "", phone: "", placeName: "", placeURL: "", roadAddress: "", x: "", y: ""))
    
    let inputCalendarData: Observable<Date?> = Observable(nil)
    
    init() {
        inputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard let date = result else { return }
            
            convertCalendarData(date: date)
        }
    }
    
    private func convertCalendarData(date: Date) {
        outputCalendarData.value = date.toString()
    }
}
