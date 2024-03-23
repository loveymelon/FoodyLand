//
//  WebViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/23/24.
//

import UIKit
import WebKit
import Then

class WebViewController: BaseViewController<WebView> {
    
    var url: String = "" {
        didSet {
            url = checkURL(url)
            loadWebView(url: url)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.webView.navigationDelegate = self
    }
    
}

extension WebViewController {
    func loadWebView(url: String) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        mainView.webView.load(urlRequest)
    }
    
    func checkURL(_ urlString: String) -> String {
        var url = urlString
        let httpFlag = url.hasPrefix("http://")
        let httpsFlag = url.hasPrefix("https://")
        
        if !httpFlag && !httpsFlag {
            url = "https://\(url)"
        }
        
        return url
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        mainView.indicator.isHidden = false
        mainView.indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.indicator.stopAnimating()
        mainView.indicator.isHidden = true
        guard let title = webView.title else { return }
        navigationItem.title = title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mainView.indicator.stopAnimating()
        mainView.indicator.isHidden = true
    }
}
