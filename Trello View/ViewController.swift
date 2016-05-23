//
//  ViewController.swift
//  Trello View
//
//  Created by Skylar Schipper on 3/4/16.
//  Copyright © 2016 Ministry Centered. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = WKWebView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.navigationDelegate = self

        self.view.addSubview(view)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": view]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": view]))
        webView = view

        loadRoot()
        
    }

    @IBAction func refreshPage(sender: AnyObject?) {
        guard let webView = webView else {
            fatalError("No web view")
        }

        webView.reload()
    }

    @IBAction func goHome(sender: AnyObject?) {
        loadRoot()
    }

    @IBAction func copyURL(sender: AnyObject?) {
        guard let webView = webView else {
            fatalError("No web view")
        }

        guard let url = webView.URL else {
            AppDelegate.playSound("Basso")
            NSLog("Failed to copy URL.  WebView returned nil for URL")
            return
        }

        let content = [url]

        NSPasteboard.generalPasteboard().clearContents()
        if NSPasteboard.generalPasteboard().writeObjects(content) {
            AppDelegate.playSound("Glass")
        } else {
            AppDelegate.playSound("Basso")
            NSLog("Failed to copy URL.  Pasteboard write failed")
        }
    }

    func loadRoot() {
        guard let webView = webView else {
            fatalError("No web view to load")
        }
        guard let URL = NSURL(string: "https://trello.com") else {
            fatalError("Failed to get URL")
        }

        let request = NSURLRequest(URL: URL)

        webView.loadRequest(request)
    }

    // MARK: - Nav Delegate
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .LinkActivated else {
            decisionHandler(.Allow)
            return
        }

        guard let url = navigationAction.request.URL else {
            AppDelegate.playSound("Basso")
            NSLog("No URL to open")
            decisionHandler(.Cancel)
            return
        }

        guard let host = url.host else {
            decisionHandler(.Allow)
            return
        }

        guard !host.containsString("trello.com") else {
            decisionHandler(.Allow)
            return
        }

        if NSWorkspace.sharedWorkspace().openURL(url) {
            decisionHandler(.Cancel)
        } else {
            decisionHandler(.Allow)
        }
    }
}
