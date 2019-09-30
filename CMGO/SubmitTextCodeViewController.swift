//
//  SubmitTextCodeViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/28/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubmitTextCodeViewController: UIViewController {

    @IBOutlet weak var codeTextInput: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitEnabled(false)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        codeTextInput.becomeFirstResponder()
    }
    

    @IBAction func submit(_ sender: UIButton) {
        print("sub")
        codeTextInput.resignFirstResponder()
        networkManager.submitCode(code: codeTextInput.text) { (success, msg) in
            var title :String
            if success{
                title = "Felicidades"
            }
            else{
                title = "Error"
            }
            self.present(alertDefault(title: title, message: msg),animated: true)
        }
        
    }
    
    @IBAction func editChanged(_ sender: UITextField) {
        
        submitEnabled(sender.text?.count ?? 0 > 0)
    }
    func submitEnabled(_ isEnabled:Bool){
        if isEnabled{
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = ColorPalette.LightGreen
            submitBtn.layer.shadowOpacity = 0.2;
        }
        else{
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = ColorPalette.SystemGray2
            submitBtn.layer.shadowOpacity = 0;
        }
    }


}
