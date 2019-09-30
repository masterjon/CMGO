//
//  BlogViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/29/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class BlogViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://cmgo.org.mx/blog/")!))
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        loadingIndicator.stopAnimating()
    }
}
