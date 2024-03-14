//
//  FoodyMapViewModel.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import Foundation

class FoodyMapViewModel {
    let outputLocationValue: Observable<[Double]> = Observable([])
    
    let inputLocationValue: Observable<Address?> = Observable(nil)
    
    init() {
        inputLocationValue.bind { result in
            guard let value = result else { return }
            
            self.converValue(data: value)
        }
    }
    
    private func converValue(data: Address) {
        guard let x = Double(data.x) else { return }
        guard let y = Double(data.y) else { return }
        
        self.outputLocationValue.value = [x, y]
    }
}
