//
//  ExamenViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/27/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON

class ExamenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let keychain = Keychain()
    var testList = [Test]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
//        present(vc,animated: true,completion:{ () in
//            self.getRemoteTests()
//        } )
        
        getRemoteTests()
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let test = testList[indexPath.row]
            let vc = segue.destination as! ExamenDetalleViewController
            vc.test = test
        }
    }
    
    func getRemoteTests(){

        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/sedes", headers:getHttpHeaders()).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    for test in json["msg"].arrayValue{
                        print(test["id"].stringValue)
                        if test["id_sede"].stringValue == "64" {
                            continue
                        }
                        let testItem = Test(id: test["id_sede"].stringValue, lat:test["latitud"].floatValue , lang: test["longitud"].floatValue, location: test["sede"].stringValue, state: test["estado"].stringValue, region: test["municipio"].stringValue, address:test["direccion"].stringValue, capacity: test["cupo"].stringValue, date: test["fecha"].stringValue,
                            timeStart:test["hora_inicio"].stringValue,
                            timeEnd: test["hora_fin"].stringValue)
                        
                        self.testList.append(testItem)
                        
                    }
                }
                self.tableView.reloadData()
                print(self.testList)
                
            case .failure(let error):
                print(error)
                
            }
            
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
extension ExamenViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestTableViewCell
        let test = testList[indexPath.row]
        cell.titleLabel.text = test.location
        cell.dateLabel.text = test.formatedDate()
        cell.timeLabel.text = test.formatedTimeRange()
        return cell
    }
}
