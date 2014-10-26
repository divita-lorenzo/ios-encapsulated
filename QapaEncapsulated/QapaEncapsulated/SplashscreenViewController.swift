//
//  SplashscreenViewController.swift
//  QapaEncapsulated
//
//  Created by Lorenzo DI VITA on 08/10/2014.
//  Copyright (c) 2014 Lorenzo DI VITA. All rights reserved.
//

import UIKit
import WebKit

class SplashscreenViewController: UIViewController, WKNavigationDelegate
{
    // MARK: Properties
    
    var orignalY : CGFloat!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    
    var homeUrlRequest: NSURLRequest!
    var firstWebView: WKWebView!
    
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.logoImageView.hidden = true
        self.loadingView.hidden = true
        self.logoImageView.alpha = 0
        self.loadingView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.orignalY = self.logoImageView.frame.origin.y
        self.logoImageView.frame.origin.y = 0
        
        UIView.animateWithDuration(1.25, animations: ({
            self.logoImageView.hidden = false
            self.logoImageView.frame.origin.y = self.orignalY
            self.logoImageView.alpha = 1
        }), completion:({
            (finished: Bool) in
            UIView.animateWithDuration(0.25, animations: ({
                self.loadingView.hidden = false
                self.loadingView.alpha = 1
            }), completion: ({
                (finished: Bool) in
                // Loading webview mechanism with AFNetworking & closure success
                self.homeUrlRequest = createUrlRequest("\(qapaMobileRootUrl)\(qapaMobilePath)\(qapaHomePath)")
//                UIWebView().loadRequest(self.homeUrlRequest, progress: nil, success: ({
//                    (response: NSHTTPURLResponse!, html:String!) in
//                    println(html)
//                    self.htmlContent = html
//                    self.performSegueWithIdentifier("splashToWebViewSegue", sender: nil)
//                    return nil
//                }), failure: nil)
                // Webview configuration
                let preferences = WKPreferences()
                preferences.javaScriptCanOpenWindowsAutomatically = false
                
                let configuration = WKWebViewConfiguration()
                configuration.preferences = preferences
                
                // Webview layout
                self.firstWebView = WKWebView(frame: self.view.bounds, configuration: configuration)
                self.firstWebView.navigationDelegate = self
                
                self.firstWebView.loadRequest(self.homeUrlRequest)
            }))
        }))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Destination -> First WebViewController
        let navigationController = segue.destinationViewController as UINavigationController
        let webViewController = navigationController.childViewControllers[0] as WebViewController
        webViewController.identifier = 1
        webViewController.webView = self.firstWebView
        webViewController.webViewLoaded = true
        webViewController.urlToLoad = self.homeUrlRequest.URL.absoluteString
    }
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!)
    {
        println("DID FINISH NAVIGATION: \(webView.URL?.absoluteString?)")
        self.performSegueWithIdentifier("splashToWebViewSegue", sender: nil)
    }
}
