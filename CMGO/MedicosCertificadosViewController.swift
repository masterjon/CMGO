//
//  MedicosCertificadosViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/4/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class MedicosCertificadosViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        webView.loadRequest(URLRequest(url: URL(string: "https://cmgo.org.mx/core/index.php/medicos_certificados")!))
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        loadingIndicator.stopAnimating()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
