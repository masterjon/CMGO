//
//  NetworkManager.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/29/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NetworkManager {
    func submitCode(code:String?,completion:@escaping(Bool,String)->()){
        let url = "https://cmgo.org.mx/core/index.php/api/v1/Services/codigoQR"
        guard let token = getUserToken() else{ return}
        guard let code = code else {return}
        let postData : [String:String] = [
            "cmgo_user_token": token,
            "codigo": code
        ]
        Alamofire.request(url, method: .post, parameters: postData, headers:getHttpHeaders()).validate().responseJSON { response in
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["status"].boolValue{
                    completion(true,"Su constancia ha sido agregada exitosamente a su cédula.")
                }
                else{
                    let message = json["msg"].stringValue
                    completion(false,message)
                }
            case .failure:
                if response.response?.statusCode == 400{
                    guard let data = response.data, let json = try? JSON(data: data) else{return}
                    let message = json["msg"].stringValue
                    completion(false,message)
                }
                else{
                    completion(false,"Hubo un error, inténtalo más tarde")
                }
            }
        }
    }
    
    func getImage(url:String, completion:@escaping(UIImage?)->()){
        Alamofire.request(url).responseData { (response) in
            if let data = response.data
            {
                completion(UIImage(data: data))
            }
            else{
                completion(nil)
            }
        }
    }
    // Do any additional setup after loading the view.
}
