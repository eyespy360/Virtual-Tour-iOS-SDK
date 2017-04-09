//
//  WebViewController.swift
//  Virtual-Tour-iOS-SDK
//
//  Copyright © 2017 EyeSpy360. All rights reserved.
//

import UIKit
import WebKit

protocol EyeSpy360ViewControllerDelegate: class {
    func eyeSpy360DidClose(_ viewController: EyeSpy360ViewController)
    func eyeSpy360(_ viewController: EyeSpy360ViewController, didPublishAt url: URL)
}

class EyeSpy360ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    weak var delegate: EyeSpy360ViewControllerDelegate?
    var url: URL?
    
    internal var webView: WKWebView!

    override func viewDidLoad() {
       super.viewDidLoad()
        
        title = "Loading"
                
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        webView.navigationDelegate = self
        self.webView = webView
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    internal func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let jsonString = message.body as? String,
            let jsonData = jsonString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let data = jsonObject as? Dictionary<String, Any>,
            let id = data["id"] as? String
            else
        {
            print("invalid payload")
            return
        }
        
        switch id {
        case "closed":
            delegate?.eyeSpy360DidClose(self)
            
        case "published":
            if let urlString = data["data"] as? String, let url = URL(string: urlString) {
            
                delegate?.eyeSpy360(self, didPublishAt: url)
            } else {
                delegate?.eyeSpy360DidClose(self)
            }
            
        default:
            print("unsupported message id: \(id)")
        }
        
    }
    
    @objc private func dismissViewController() {
        delegate?.eyeSpy360DidClose(self)
    }
    
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoadingError()
    }
    
    internal func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showLoadingError()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = "EyeSpy360"
    }
    
    private func showLoadingError() {
        let alertController = UIAlertController(title: "Error", message: "Failed to load", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.eyeSpy360DidClose(self)
        }))
        
        present(alertController, animated: true)
    }
}
