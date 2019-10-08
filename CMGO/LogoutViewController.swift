//
//  LogoutViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/5/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import KeychainAccess

class LogoutViewController: UIViewController {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let keychain = Keychain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        keychain["token"] = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired
            
            let home = self.storyBoard.instantiateViewController(withIdentifier: "InicioNVC")
            self.present(home,animated: true)
        }
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
