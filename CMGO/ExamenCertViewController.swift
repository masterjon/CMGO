//
//  ExamenCertViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/1/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class ExamenCertViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var hasLoaded = false
    var delegate : TabDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = getUserToken(), !hasLoaded{
            loadingIndicator.startAnimating()
            let url = "https://cmgo.org.mx/core/index.php/api/v1/render/estatusCertificacion/\(token)"
            webView.loadRequest(URLRequest(url: URL(string: url)!))
            print(token)
        }
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        loadingIndicator.stopAnimating()
        hasLoaded = true
    }

}
