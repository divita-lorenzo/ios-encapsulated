//
//  WebViewController.swift
//  QapaEncapsulated
//
//  Created by Lorenzo DI VITA on 06/10/2014.
//  Copyright (c) 2014 Lorenzo DI VITA. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate
{
    // MARK: Properties
    
    var webView: WKWebView!
    var webViewLoaded = false
    var urlToLoad: String?
    var contentLoaded : String?
    var identifier = 0
    
    
    // MARK: ViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Webview configuration
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        // Webview layout
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
//        if self.urlToLoad == nil {
//            self.urlToLoad = "\(qapaMobileRootUrl)\(qapaMobilePath)\(qapaHomePath)"
//        }
        
        // Loading webview
        if self.contentLoaded !=  nil {
            let request = createUrlRequest("\(qapaMobileRootUrl)\(qapaMobilePath)\(qapaHomePath)")
            self.webView.loadHTMLString(self.contentLoaded, baseURL: request.URL.baseURL)
        }
        
        else {
            self.webView.loadRequest(createUrlRequest(self.urlToLoad!))
        }
        
        // View controller & webview association + delegate definition
        self.view = self.webView
        self.webView.navigationDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        // Hack to reload right content on back action
        if self.urlToLoad != nil {
            self.webViewLoaded = false
            self.webView.loadRequest(createUrlRequest(self.urlToLoad))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: WKNavigationDelegate methods
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!)
    {
        println("DID FINISH NAVIGATION: \(webView.URL.absoluteString?)")
        
        // Flag for webview marked as loaded
        self.webViewLoaded = true
    }
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!)
    {
        println("POLICY REQUEST for WebVC \(self.identifier): \(navigationAction.request.URL.absoluteString)")
        
        // Check path containing Qapa Root URL or not
        if self.webViewLoaded && self.urlToLoad != navigationAction.request.URL.absoluteString && navigationAction.request.URL.absoluteString?.rangeOfString(qapaMobileRootUrl, options: nil, range: nil, locale: NSLocale.currentLocale()) != nil
        {
            // Cancel webview navigation
            decisionHandler(WKNavigationActionPolicy.Cancel)
            self.webView.stopLoading()
            
            // Push new webview controller to  navigation controller
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as WebViewController
            webVC.urlToLoad = navigationAction.request.URL.absoluteString
            webVC.identifier++
            self.navigationController?.pushViewController(webVC, animated: true)
        }
            
        else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    func webView(webView: WKWebView!, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse!, decisionHandler: ((WKNavigationResponsePolicy) -> Void)!) {
        decisionHandler(WKNavigationResponsePolicy.Allow)
        println("POLICY RESPONSE  for WebVC \(self.identifier): \(navigationResponse.response.URL?.absoluteString)")
    }
}

