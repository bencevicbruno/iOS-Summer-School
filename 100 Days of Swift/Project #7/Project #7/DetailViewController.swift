import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, inital-scale=1">
                    <style>
                    body {
                        font-size: 150%;
                        padding: 5%;
                        background-color: #BADA55;
                    }
                    </style>
                </head>
                <body>
                \(detailItem.body)
                </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
