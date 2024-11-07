//
//  BaseViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import UIKit

class BaseViewController<T: BaseView>: UIViewController {

    let mainView = T()
    
    override func loadView() {
        self.view = mainView
        
        dataSourceDelegate()
        configureNav()
        bindData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func dataSourceDelegate() {
        
    }
    
    func configureNav() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .customYellow
        
        self.navigationController?.navigationItem.titleView?.tintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func bindData() {
        
    }

}
