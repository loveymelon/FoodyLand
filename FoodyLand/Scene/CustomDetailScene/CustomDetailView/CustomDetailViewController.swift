//
//  CustomDetailViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/11/24.
//

import UIKit
import FloatingPanel
import Then

// 서치 화면에 아무것도 없을때 화면 구성하고 cellConfigure따로 빼기 오늘은 공수산정 꼭 정하자

final class CustomDetailViewController: BaseViewController<CustomDetailView> {
    
    lazy var fpVC = FloatingPanelController().then {
        let calendarVC = CalendarViewController() // 이렇게 되면 CustomDetailViewController이 메모리에 올라올때 같이 올라온다 이걸 어떻게 수정할지 고민해보자
        calendarVC.delegate = self
        $0.set(contentViewController: calendarVC)
        $0.isRemovalInteractionEnabled = true
        $0.layout = MyFloatingPanelLayout()
    }

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
        
        customDetailViewModel.outputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard !result.isEmpty else { return }
            mainView.calendarLabel.text = result
        }
    }
    
    override func dataSourceDelegate() {
        fpVC.delegate = self
    }
    
}

extension CustomDetailViewController {
    private func buttonAddAction() {
        mainView.calendarButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            fpVC.addPanel(toParent: self)
        }), for: .touchUpInside)
        
        mainView.saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            guard let rootVC = self.navigationController?.viewControllers[0] as? FoodyMapViewController else { return }
            
            rootVC.foodyMapViewModel.inputLocationValue.value = customDetailViewModel.inoutputDetailData.value
            
            self.navigationController?.popToRootViewController(animated: true)
        }), for: .touchUpInside)
        
        mainView.categoryButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            let categoryVC = CategoryViewController()
            
            categoryVC.delegate = self
            categoryVC.modalPresentationStyle = .automatic
            
            self.present(categoryVC, animated: true)
            
        }), for: .touchUpInside)
    }
    
}

extension CustomDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
//        fpc.removePanelFromParent(animated: true)
        return true
    }
}

extension CustomDetailViewController: CalendarDataDelegate {
    func selectedDate(date: Date) {
        print(date)
        customDetailViewModel.inputCalendarData.value = date
    }
}

extension CustomDetailViewController: CategoryDataDelegate {
    func passCategoryData(res: String) {
        mainView.categoryLabel.text = res
    }
}
