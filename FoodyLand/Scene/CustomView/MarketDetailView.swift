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
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }

    let marketImageView = UIImageView().then {
        $0.image = .basic
        $0.isUserInteractionEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .white
        $0.currentPageIndicatorTintColor = .red
        $0.backgroundColor = .black
        $0.currentPage = 0
    }
    
    let marketTitleImageView = UIImageView().then {
        $0.image = .home
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
        $0.image = .global
    }
    
    let marketURLLabel = UILabel().then {
        $0.text = "aaa"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 16)
        $0.isUserInteractionEnabled = true
    }
    
    let marketURLStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    let marketAddImageView = UIImageView().then {
        $0.image = .location
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
        
        self.backgroundColor = .customYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(scrollView)
        self.scrollView.addSubview(marketImageView)
        self.marketImageView.addSubview(pageControl)
        
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
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(self.scrollView.snp.width).multipliedBy(0.9)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        marketImageView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(70)
//            make.height.equalTo(self.marketImageView.snp.width).multipliedBy(0.9)
//            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(self.marketImageView.snp.bottom)
            make.width.equalTo(self.marketImageView.snp.width)
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
            make.top.equalTo(self.scrollView.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
    }
    
}
