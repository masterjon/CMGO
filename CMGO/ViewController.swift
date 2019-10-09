//
//  ViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/19/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImageSlideshow

class ViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    var slidesUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        //deleteUserToken()
        //getSlides()
//        let t = getMyTests()
//        print(t)
//        getPendingNotif()
//
        // Do any additional setup after loading the view.
    }
    @objc func didTap() {
        let url = slidesUrls[slideshow.currentPage]
        openUrl(url)
    }
    func getSlides(){
        Alamofire.request("https://cmgo.iddeasapps.xyz/api/v1/slides/").validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                if let json = JSON(value).arrayValue.first{
                    var imageSources = [AlamofireSource]()
                    for slide in json["slides"].arrayValue{
                        imageSources.append(AlamofireSource(urlString: slide["image"].stringValue)!)
                        self.slidesUrls.append(slide["url"].stringValue)
                    }
                    self.slideshow.setImageInputs(imageSources)
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                    self.slideshow.addGestureRecognizer(gestureRecognizer)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func apiTest(){
        let headers: HTTPHeaders = [
            "CMGO_API_KEY": "ZCn76kBSJ2LE7wJ3S4O8WwiLWLywJLW8LZpWe3HA",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let postData = [
            "cedula": "11223344",
            "password": "123456"
        ]
        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/login", method: .post, parameters: postData, headers:headers).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    if let token = json["msg"]["cmgo_user_token"].string{
                        print(token)
                        
                        let postData2 = [
                            "cmgo_user_token": token,
                        ]
                        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/sedes", method: .post, parameters: postData2, headers:headers).validate().responseJSON { (response) in
                            
                            print(response)
                        }
                    }
                }
                else{
                    print("Credenciales incorrectas")
                }
            case .failure(let error):
                print("Hubo un error, verifica tus credenciales")
                print(error)
            }
            
            print(response)
        }
        
    }
}

