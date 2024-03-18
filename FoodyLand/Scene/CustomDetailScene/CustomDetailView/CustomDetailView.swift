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

final class CustomDetailView: BaseView {
    
    let marketDetailView = MarketDetailView()
    
    private let starLabel = UILabel().then {
        $0.text = "별점"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let starView = CosmosView().then {
        $0.settings.fillMode = .full
        $0.settings.starSize = 30
        $0.settings.starMargin = 5
        $0.text = "3"
        $0.settings.starMargin = 10
        $0.settings.filledImage = .rice
        $0.settings.emptyImage = .dish
    }
    
    private let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    let calendarButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = .calendar
        
        let button = UIButton(configuration: buttonConfig)
        
        return button
    }()
    
    let calendarLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = Date().toString()
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    let categoryButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = .category
        
        let button = UIButton(configuration: buttonConfig)
        return button
    }()
    
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
    }
    
    private let calendarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    private let otherDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .equalSpacing
    }
    
    private let memoLabel = UILabel().then {
        $0.text = "메모"
    }
    
    let memoTextView = UITextView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    
    let saveButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "저장"
        buttonConfig.baseBackgroundColor = .customOrange
        let button = UIButton(configuration: buttonConfig)
        
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        
        starViewSetting()
        self.backgroundColor = .customYellow
    }
    
    override func configureHierarchy() {
        self.addSubview(marketDetailView)
        
        [starLabel, starView].forEach { items in
            starStackView.addArrangedSubview(items)
        }
        
        [calendarButton, calendarLabel, lineView, categoryButton, categoryLabel].forEach { items in
            calendarStackView.addArrangedSubview(items)
        }
        
        [starStackView, calendarStackView].forEach { items in
            otherDetailStackView.addArrangedSubview(items)
        }
        
        self.addSubview(otherDetailStackView)
        self.addSubview(memoLabel)
        self.addSubview(memoTextView)
        self.addSubview(saveButton)
        
    }
    
    override func configureLayout() {
        marketDetailView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        starLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        starView.snp.makeConstraints { make in
            make.width.equalTo(self.starStackView.snp.width).multipliedBy(0.8)
            make.height.equalTo(starLabel)
        }
        
        starStackView.snp.makeConstraints { make in
            make.width.equalTo(self.otherDetailStackView.snp.width)

        }
        
        calendarButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        calendarLabel.snp.makeConstraints { make in
            make.height.equalTo(self.calendarButton.snp.height)
            make.width.equalTo(self.calendarStackView.snp.width).multipliedBy(0.3)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(calendarButton.snp.height)
            make.width.equalTo(1)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.size.equalTo(calendarButton.snp.size)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(calendarButton.snp.height)
            make.width.equalTo(self.calendarStackView.snp.width).multipliedBy(0.3)
        }
        
        calendarStackView.snp.makeConstraints { make in
            make.width.equalTo(self.otherDetailStackView.snp.width)
            
        }
        
        otherDetailStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(self.marketDetailView.snp.bottom).offset(5)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.otherDetailStackView.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.leading.equalTo(self.otherDetailStackView.snp.leading)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(self.memoLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self.saveButton.snp.top).offset(-10)
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
