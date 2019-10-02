//
//  AreasOportunidadViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/2/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AreasOportunidadViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var areaList = [[Area]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis Áreas de Oportunidad"
        getAreas()
    }
    
    func getAreas(){
        #if DEBUG
            let token = "A0YPkUJsmcoDFNaNmxW1VKeLcMTJqX1568399119"
        #else
            guard let token = getUserToken() else {return}
        #endif
        
        
        let params : [String:String] = [
            "cmgo_user_token": token,
        ]
        let url = "https://cmgo.org.mx/core/index.php/solicitud_puntaje/cmgo_service/contenido/"
        
        Alamofire.request(url,parameters:params, headers:getHttpHeaders()).validate().responseJSON { response in
            self.loadingIndicator.stopAnimating()
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    for parent in json["msg"].arrayValue{
                        var list = [Area]()
                        for item in parent.arrayValue{
                            let area = Area(area: item["area"].stringValue, tema: item["tema"].stringValue)
                            list.append(area)
                        }
                        self.areaList.append(list)
                    }
                    self.tableView.reloadData()
                }
                else{
                    let message = json["msg"].stringValue
                    self.errorLabel.text = message
                }
            case .failure(let error):
                print(error)
                if response.response?.statusCode == 404{
                    guard let data = response.data, let json = try? JSON(data: data) else{return}
                    let message = json["msg"].stringValue
                    self.errorLabel.text = message
                }
            }
        }
    }

}

extension AreasOportunidadViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return areaList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaList[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return areaList[section].first?.area
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = areaList[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.tema
        return cell
    }
    
    
}
