//
//  TextFieldButtonsView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/15/24.
//

import UIKit
import SnapKit

class TextFieldButtonsView: BaseView {
    
    let checkButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: FLImage.checkmarkCircle)
        let button = UIButton(configuration: buttonConfig)
        button.tintColor = .black
        return button
    }()
    
    let cancelButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: FLImage.xmarkCircle)
        let button = UIButton(configuration: buttonConfig)
        button.tintColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(cancelButton)
        self.addSubview(checkButton)
    }
    
    override func configureLayout() {
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(5)
            make.height.equalTo(22)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(cancelButton.snp.centerY)
            make.trailing.equalTo(cancelButton.snp.leading).offset(10)
        }
    }
    
}
