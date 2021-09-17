import UIKit
import WebKit

class WebpageViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var website: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openOnTap))
        
        
        
        let url = URL(string: website)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    func setupToolbar() {
        let back = UIBarButtonItem(title: "<", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: ">", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        self.toolbarItems = [back, forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func openOnTap() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in NavigationViewController.socialMediaList {
            alertController.addAction((UIAlertAction(title: website, style: .default, handler: openPage)))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // important for iPad
        
        present(alertController, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://www." + action.title! + ".com")!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if host.contains("4chan") {
                decisionHandler(.cancel)
                
                let alertController = UIAlertController(title: "Website blocked", message: "No 4chan for you!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Go back", style: .default, handler: {
                    [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                
                present(alertController, animated: true)
                return
            }
        }
        
        decisionHandler(.allow)
    }
}

