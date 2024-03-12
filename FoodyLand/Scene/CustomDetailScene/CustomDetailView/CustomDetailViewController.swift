//
//  CustomDetailViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/11/24.
//

import UIKit

// 서치 화면에 아무것도 없을때 화면 구성하고 cellConfigure따로 빼기 오늘은 공수산정 꼭 정하자

class CustomDetailViewController: BaseViewController<CustomDetailView> {

    let customDetailViewModel = CustomDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAddAction()
    }
    
    override func bindData() {
        customDetailViewModel.inoutputDetailData.bind { [weak self] result in
            guard let self = self else { return }
            
            mainView.marketDetailView.marketTitleLabel.text = result.placeName
            mainView.marketDetailView.marketURLLabel.text = result.placeURL
            mainView.marketDetailView.marketAddLabel.text = result.roadAddress
        }
    }
    
}

extension CustomDetailViewController {
    private func buttonAddAction() {
        mainView.calendarButton.addAction(UIAction(handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }), for: .touchUpInside)
        
        mainView.saveButton.addAction(UIAction(handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }), for: .touchUpInside)
    }
}
