//
//  WebViewController.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/22/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Properties
    var url: URL!
    
    // MARK: LifeCycle
    init(_ URL: URL) {
        self.url = URL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        let urlString = "https://" + url.absoluteString
        let newUrl = URL(string: urlString)
        webView.load(URLRequest(url: newUrl!))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

}

extension WebViewController: WKNavigationDelegate  {
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
    
}
