//
//  BaseView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import UIKit

class BaseView: UIView, ConfigureUIProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
}

