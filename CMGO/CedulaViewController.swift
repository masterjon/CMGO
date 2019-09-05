//
//  CedulaViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/5/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CedulaViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var itemList = [CedulaItem]()
    var total = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getScore()
        // Do any additional setup after loading the view.
    }
    
    func getScore(){
        guard let token = getUserToken() else{ return}
        
        let postData : [String:String] = [
            "cmgo_user_token": token,
        ]
        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/cedula", method: .post, parameters: postData, headers:getHttpHeaders()).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    
                    for item in json["msg"].arrayValue{
                        var puntos = 0
                        for pregunta in item["preguntas"].arrayValue{
                            for respuesta in pregunta["respuestas"].arrayValue{
                                let factor = Int(respuesta["factor"].stringValue) ?? 0
                                let puntaje = Int(respuesta["puntaje"].stringValue) ?? 0
                                puntos += (factor*puntaje)
                            }
                        }
                        let cedulaItem = CedulaItem(id: item["id"].stringValue, title: item["capitulo"].stringValue, points: puntos)
                        self.total += puntos
                        self.itemList.append(cedulaItem)
                    }
                }
                print(self.itemList)
                self.tableView.reloadData()
                self.totalLabel.text = String(self.total)
                
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
}

extension CedulaViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CedulaTableViewCell
        let item = itemList[indexPath.row]
        cell.numberLabel.text = item.id
        cell.titleLabel.text = item.title
        cell.pointsLabel.text = String(item.points)
        return cell
    }
    
    
}
