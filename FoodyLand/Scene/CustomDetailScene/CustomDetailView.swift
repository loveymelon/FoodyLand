//
//  CustomDetailView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/11/24.
//

import UIKit
import SnapKit
import Then
import Cosmos

class CustomDetailView: BaseView {
    
    let marketDetailView = MarketDetailView().then {
        $0.backgroundColor = .blue
    }
    
    let starLabel = UILabel().then {
        $0.backgroundColor = .red
        $0.text = "별점"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let starView = CosmosView().then {
        $0.settings.fillMode = .half
        $0.settings.starSize = 30
        $0.settings.starMargin = 5
        $0.text = "2.5"
        $0.backgroundColor = .gray
    }
    
    let memoTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        
        starViewSetting()
    }
    
    override func configureHierarchy() {
        self.addSubview(marketDetailView)
        self.addSubview(starView)
    }
    
    override func configureLayout() {
        marketDetailView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(10)
//            make.height.equalTo(self.marketDetailView.snp.width).multipliedBy
        }
        
        starView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
            make.top.equalTo(self.marketDetailView.snp.bottom).offset(5)
        }
    }
    
}

extension CustomDetailView {
    private func starViewSetting() {
        starView.didTouchCosmos = { [weak self] rating in
            
            guard let self = self else { return }
            
            starView.text = String(rating)
            
        }
    }
}
