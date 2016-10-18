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
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": view]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": view]))
        webView = view

        loadRoot()
        
    }

    @IBAction func refreshPage(_ sender: AnyObject?) {
        guard let webView = webView else {
            fatalError("No web view")
        }

        webView.reload()
    }

    @IBAction func goHome(_ sender: AnyObject?) {
        loadRoot()
    }

    @IBAction func copyURL(_ sender: AnyObject?) {
        guard let webView = webView else {
            fatalError("No web view")
        }

        guard let url = webView.url else {
            AppDelegate.playSound("Basso")
            NSLog("Failed to copy URL.  WebView returned nil for URL")
            return
        }

        let content = [url]

        NSPasteboard.general().clearContents()
        if NSPasteboard.general().writeObjects(content as [NSPasteboardWriting]) {
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
        guard let URL = URL(string: "https://trello.com") else {
            fatalError("Failed to get URL")
        }

        let request = URLRequest(url: URL)

        webView.load(request)
    }

    // MARK: - Nav Delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }

        guard let url = navigationAction.request.url else {
            AppDelegate.playSound("Basso")
            NSLog("No URL to open")
            decisionHandler(.cancel)
            return
        }

        guard let host = url.host else {
            decisionHandler(.allow)
            return
        }

        guard !host.contains("trello.com") else {
            decisionHandler(.allow)
            return
        }

        if NSWorkspace.shared().open(url) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
