//
//  LoginViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/30/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let loginUrl = "https://cmgo.org.mx/core/index.php/api/v1/Services/login"
    let keychain = Keychain()
    var delegate : TabDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(recognizer)
        
        usernameTextField.text = "11223344"
        passwordTextField.text = "123456"
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if let cedula = usernameTextField.text,let password = passwordTextField.text, cedula.count>5, password.count>0 {
            loginRequest(cedula: cedula, passwod: password)
        }
        else{
            present(alertDefault(title: "Debes ingresar tu cedula y contraseña"),animated: true)
            
        }
    }
    
    func loginRequest(cedula:String, passwod:String){
        loadingIndicator.startAnimating()
        
        let postData = [
            "cedula": cedula,
            "password": passwod
        ]
        
        Alamofire.request(loginUrl, method: .post, parameters: postData, headers:getHttpHeaders()).validate().responseJSON { (response) in
            self.loadingIndicator.stopAnimating()
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    if let token = json["msg"]["cmgo_user_token"].string{
                        print(token)
                        self.keychain["token"] = token
                        self.dismiss(animated: true, completion: {
                            self.delegate?.changeTab(index: 1)
                            print("dismiss")
                        })
//                        let postData2 = [
//                            "cmgo_user_token": token,
//                        ]
//                        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/sedes", method: .post, parameters: postData2, headers:headers).validate().responseJSON { (response) in
//
//                            print(response)
//                        }
                    }
                }
                else{
                    self.present(alertDefault(title: "Credenciales incorrectas"),animated: true)
                }
            case .failure(let error):
                self.present(alertDefault(title: "Hubo un error, verifica tus credenciales"), animated: true)
                print(error)
            }
            
            print(response)
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.changeTab(index: 0)
        })
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
