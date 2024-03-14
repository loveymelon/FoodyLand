//
//  MarketDetailView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/11/24.
//

import UIKit
import SnapKit
import Then

class MarketDetailView: BaseView {

    let marketImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    let marketTitleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    let marketTitleLabel = UILabel().then {
        $0.text = "aaa"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let marketTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    let marketURLImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    let marketURLLabel = UILabel().then {
        $0.text = "aaa"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let marketURLStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    let marketAddImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    let marketAddLabel = UILabel().then {
        $0.text = "aaa"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let marketAddStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    let marketDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(marketImageView)
        
        [marketTitleImageView, marketTitleLabel].forEach { items in
            marketTitleStackView.addArrangedSubview(items)
        }
        
        [marketURLImageView, marketURLLabel].forEach { items in
            marketURLStackView.addArrangedSubview(items)
        }
        
        [marketAddImageView, marketAddLabel].forEach { items in
            marketAddStackView.addArrangedSubview(items)
        }
        
        [marketTitleStackView, marketURLStackView, marketAddStackView].forEach { items in
            marketDetailStackView.addArrangedSubview(items)
        }
        
        self.addSubview(marketDetailStackView)
    }
    
    override func configureLayout() {
        marketImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(self.marketImageView.snp.width)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        marketTitleImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        marketTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(self.marketTitleImageView.snp.height)
            make.width.equalTo(self.marketTitleStackView.snp.width).multipliedBy(0.8)
        }
        
        marketTitleStackView.snp.makeConstraints { make in
            make.width.equalTo(self.marketDetailStackView.snp.width)
        }
        
        marketURLImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        marketURLLabel.snp.makeConstraints { make in
            make.height.equalTo(self.marketURLImageView.snp.height)
            make.width.equalTo(self.marketURLStackView.snp.width).multipliedBy(0.8)
        }
        
        marketURLStackView.snp.makeConstraints { make in
            make.width.equalTo(self.marketDetailStackView.snp.width)
        }
        
        marketAddImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        marketAddLabel.snp.makeConstraints { make in
            make.height.equalTo(self.marketAddImageView.snp.height)
            make.width.equalTo(self.marketAddStackView.snp.width).multipliedBy(0.8)
        }
        
        marketAddStackView.snp.makeConstraints { make in
            make.width.equalTo(self.marketDetailStackView.snp.width)
        }
        
        marketDetailStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(self.marketImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
    }
    
}
