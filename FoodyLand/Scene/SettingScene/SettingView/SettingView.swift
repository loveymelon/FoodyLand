//
//  SettingView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/23/24.
//

import UIKit
import Then
import SnapKit

class SettingView: BaseView {
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        $0.separatorStyle = .none
        $0.backgroundColor = .customYellow
        $0.isScrollEnabled = false
        $0.rowHeight = 100
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .customYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
