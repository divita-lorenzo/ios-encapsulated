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
        if self.urlToLoad == nil {
            self.urlToLoad = "\(qapaMobileRootUrl)\(qapaMobilePath)\(qapaHomePath)"
            
            // TODO : Loading webview mechanism with AFNetworking & closure success
            //            UIWebView().loadRequest(request, progress: nil, success: ({(response: NSHTTPURLResponse!, html:String!) in
            //                println(html)
            //                self.webView.loadHTMLString(html, baseURL: request.URL)
            //                return nil}), failure: nil)
            
        }
        
        // Loading webview
        self.webView.loadRequest(createUrlRequest(self.urlToLoad!))
        
        // View controller & webview association + delegate definition
        self.view = self.webView
        self.webView.navigationDelegate = self
    }
    
//    override func viewDidDisappear(animated: Bool)
//    {
//        super.viewDidDisappear(animated)
//        
//        // Hack to reload right content on back action
//        if self.urlToLoad != nil {
//            self.webView.loadRequest(createUrlRequest(self.urlToLoad))
//        }
//    }
    
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
        println("POLICY ACTION : \(webView.URL.absoluteString?)")
        
        if self.webViewLoaded
        {
            // Cancel webview navigation
            decisionHandler(WKNavigationActionPolicy.Cancel)
            self.webView.stopLoading()
            
//            // Push new webview controller to  navigation controller
//            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as WebViewController
//            webVC.urlToLoad = webView.URL.absoluteString
//            self.navigationController?.pushViewController(webVC, animated: true)
        }
            
        else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
        
    }
    
    func webView(webView: WKWebView!, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse!, decisionHandler: ((WKNavigationResponsePolicy) -> Void)!) {
        decisionHandler(WKNavigationResponsePolicy.Allow)
        println("POLICY RESPONSE : \(webView.URL.absoluteString?)")
    }
    
    func webView(webView: WKWebView!, didCommitNavigation navigation: WKNavigation!) {
        println("DID COMMIT NAVIGATION: \(webView.URL.absoluteString?)")
    }
    
    func webView(webView: WKWebView!, didStartProvisionalNavigation navigation: WKNavigation!) {
        println("DID START PROVISIONAL NAVIGATION: \(webView.URL.absoluteString?)")
    }
    
    func webView(webView: WKWebView!, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        println("DID RECEIVE SERVER REDIRECT: \(webView.URL.absoluteString?)")
    }
}

