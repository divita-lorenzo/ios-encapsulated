//
//  ViewController.swift
//  QapaEncapsulated
//
//  Created by Lorenzo DI VITA on 06/10/2014.
//  Copyright (c) 2014 Lorenzo DI VITA. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate
{
    // MARK: Properties
    
    var webView: WKWebView!
    var loadingTimes = 0
    var urlToLoad: NSURL?
    
    
    // MARK: ViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        if self.urlToLoad == nil {
            let URL = NSURL(string: "http://m.qapa.fr/mobile/index/index")
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
            
            //            UIWebView().loadRequest(request, progress: nil, success: ({(response: NSHTTPURLResponse!, html:String!) in
            //                println(html)
            //                self.webView.loadHTMLString(html, baseURL: request.URL)
            //                return nil}), failure: nil)
            
        }
            
        else {
            self.webView.loadRequest(NSURLRequest(URL: self.urlToLoad!))
        }
        
        
        self.view = self.webView
        self.webView.navigationDelegate = self
        
        // AFNETWORKING WEBVIEW + SESSION MANAGER
        
        //        UIWebView().loadRequest(request, progress: nil, success: ({(response: NSHTTPURLResponse!, html:String!) in
        //            println(html)
        //            self.webView.loadHTMLString(html, baseURL: request.URL)
        //            return html}), failure: nil)
        
        
        //        let manager = AFHTTPSessionManager()
        //        manager.responseSerializer = AFHTTPResponseSerializer()
        //        // Accept formats
        //        manager.responseSerializer.acceptableContentTypes = NSSet(array:["text/html", "text/plain"])
        //        manager.GET(
        //            "http://m.qapa.fr/mobile/index/index",
        //
        //            parameters: nil,
        //            success: { (operation: NSURLSessionDataTask!, responseObject: AnyObject!) in
        //                println("Response: " + responseObject.description)
        //            },
        //            failure: { (operation: NSURLSessionDataTask!,
        //                error: NSError!) in
        //                println("Error: " + error.localizedDescription)
        //        })
        //        let op = AFHTTPRequestOperation(request: request)
        //        op.responseSerializer = AFHTTPResponseSerializer()
        //        op.setCompletionBlockWithSuccess({ (op: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        //            println(response)
        //            }, failure: { (op: AFHTTPRequestOperation!, error: NSError!) -> Void in
        //            println(error)
        //        })
        //
        //        NSOperationQueue.mainQueue().addOperation(op)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: WKNavigationDelegate methods
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!)
    {
        decisionHandler(WKNavigationActionPolicy.Allow)
        
        println("POLICY ACTION : \(webView.URL.absoluteString?)")
        
        //     if let range = webView.URL.absoluteString?.rangeOfString("http://m.qapa.fr", options: nil, range: nil, locale: NSLocale.currentLocale()) {
        if (self.urlToLoad == nil && "http://m.qapa.fr/mobile/index/index" != webView.URL.absoluteString?) || self.urlToLoad?.absoluteString == webView.URL.absoluteString?
        {
            if self.loadingTimes == 0 {
                decisionHandler(WKNavigationActionPolicy.Allow)
                self.loadingTimes++
            }
                
            else
            {
                decisionHandler(WKNavigationActionPolicy.Cancel)
                let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("web") as ViewController
                webVC.urlToLoad = webView.URL
                self.navigationController?.pushViewController(webVC, animated: true)
            }
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
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        println("DID FINISH NAV: \(webView.URL.absoluteString?)")
    }
}

