//
//  WebView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/23/24.
//

import UIKit
import WebKit

class WebView: BaseView {

    let webView = WKWebView()
    let indicator = UIActivityIndicatorView().then {
        $0.isHidden = true
        $0.color = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(webView)
        self.addSubview(indicator)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(webView)
        }
    }
}
