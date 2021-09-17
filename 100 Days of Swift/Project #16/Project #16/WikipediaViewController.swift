//
//  WikipediaViewController.swift
//  Project #16
//
//  Created by Bruno Benčević on 8/13/21.
//

import UIKit
import WebKit

class WikipediaViewController: UIViewController, WKNavigationDelegate {

    var city: String!
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = city
        
        webView.load(URLRequest(url: URL(string: "https://www.wikipedia.org/wiki/\(city!)")!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if host.contains("wikipedia") {
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.cancel)
    }
}
