//
//  UIViewController+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import UIKit

extension UIViewController {
    func showSettingAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세요")
            }
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showImageAlert(bool: Bool, deleteCompletionHandler: @escaping () -> Void, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let oneButton = UIAlertAction(title: "취소", style: .cancel)
        let twoButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            deleteCompletionHandler()
        }
        let threeButton = UIAlertAction(title: "추가", style: .default) { _ in
            completionHandler()
        }
        
        alert.addAction(oneButton)
        alert.addAction(twoButton)
        alert.addAction(threeButton)
        
        // 4. 띄우기
        present(alert, animated: true)
    }
}
