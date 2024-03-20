//
//  FoodyMapViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation

class FoodyMapViewModel {
    let outputLocationValue: Observable<[Double]> = Observable([])
    
    let inputLocationValue: Observable<Location?> = Observable(nil)
    
    init() {
        inputLocationValue.bind { [weak self] result in
            guard let self else { return }
            guard let value = result else { return }
            
            self.converValue(data: value)
        }
    }
    
    private func converValue(data: Location) {
        outputLocationValue.value = [data.latitude, data.longitude]
    }
}
