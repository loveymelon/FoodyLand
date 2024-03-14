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
    
    private let starView = CosmosView().then {
        $0.settings.fillMode = .half
        $0.settings.starSize = 30
        $0.settings.starMargin = 5
        $0.text = "2.5"
        $0.settings.starMargin = 10
    }
    
    private let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    var calendarButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: "calendar")
        
        let button = UIButton(configuration: buttonConfig)
        
        return button
    }()
    
    let calendarLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "날짜"
    }
    
    private let calendarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
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
    
    private let memoTextView = UITextView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }
    
    let saveButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "저장"
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
    }
    
    override func configureHierarchy() {
        self.addSubview(marketDetailView)
        
        [starLabel, starView].forEach { items in
            starStackView.addArrangedSubview(items)
        }
        
        [calendarButton, calendarLabel].forEach { items in
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
            make.width.equalTo(self.calendarStackView.snp.width).multipliedBy(0.8)
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
