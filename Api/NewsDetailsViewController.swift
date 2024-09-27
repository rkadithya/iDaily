//
//  NewsDetailsViewController.swift
//  Api
//
//  Created by apple on 30/07/24.
//

import UIKit
import WebKit
import ProgressHUD
class NewsDetailsViewController: UIViewController,WKNavigationDelegate {
    var webView:WKWebView!
    var url:URL!
//HomeToNewsDetails
    override func viewDidLoad(){
        super.viewDidLoad()
        webView = WKWebView(frame:self.view.frame)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        loadURL()
    }
    
    func loadURL(){
        let request = URLRequest(url: url)
        if let url{
            webView.load(request)
            ProgressHUD.animationType = .ballVerticalBounce
            ProgressHUD.animate()
            ProgressHUD.colorBackground = .black
        
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        print(error)
    }
 
}

