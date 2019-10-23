//
//  RedesViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/29/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class RedesViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://cmgo.iddeasapps.xyz/api/v1/social/")!))
        
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        loadingIndicator.stopAnimating()
        
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
}
