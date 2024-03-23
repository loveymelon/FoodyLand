//
//  SettingViewViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/23/24.
//

import UIKit

class SettingViewViewController: BaseViewController<SettingView> {

    let settingViewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func dataSourceDelegate() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    override func configureNav() {
        super.configureNav()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
    }
    
    override func bindData() {
        settingViewModel.outputDetailDatas.bind { [weak self] result in
            guard let self else { return }
            guard !result.isEmpty else { return }
            
            deleteData(id: result)
        }
    }
    
}

extension SettingViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = SettingEnum.allCases[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 20)
        cell.backgroundColor = .customYellow
        cell.imageView?.image = UIImage(systemName: "star")
        cell.selectionStyle = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SettingEnum.allCases[indexPath.row] {
        case .notice, .help, .qa:
            tableView.deselectRow(at: indexPath, animated: true)
            let webVC = WebViewController()
            
            webVC.url = "https://www.notion.so/77292ae6c88e43be9dfa014edca42ea6"
            
            self.present(webVC, animated: true)
        case .reset :
            tableView.deselectRow(at: indexPath, animated: true)
            settingViewModel.inputDeleteTrigger.value = ()
        }
    }
    
    
}

extension SettingViewViewController {
    private func deleteData(id: [String]) {
        
        for item in id {
            let result = removeImageFile(fileName: item)
            
            switch result {
            case .success():
                print("success")
                settingViewModel.inputDeleteAllTrigger.value = ()
            case .failure(let failuer):
                print(failuer)
            }
        }
        
    }
}
