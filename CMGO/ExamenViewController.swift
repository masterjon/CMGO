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
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        present(vc,animated: true,completion:{ () in
            self.getRemoteTests()
        } )
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func getRemoteTests(){
        guard let token = getUserToken() else{ return}
        
        let postData : [String:String] = [
                "cmgo_user_token": token,
            ]
        Alamofire.request("https://cmgo.org.mx/core/index.php/api/v1/Services/sedes", method: .post, parameters: postData, headers:getHttpHeaders()).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if json["status"].boolValue{
                    for test in json["msg"].arrayValue{
                        var dates = [TestDate]()
                        for date in test["fechas"].arrayValue{
                            let dateItem = TestDate(date: date["fecha"].stringValue, timeStart: date["hora_inicio"].stringValue, timeEnd: date["hora_fin"].stringValue)
                            dates.append(dateItem)
                        }
                        let testItem = Test(id: test["id_sede"].stringValue, lat:test["latitud"].floatValue , lang: test["longitud"].floatValue, location: test["sede"].stringValue, state: test["estado"].stringValue, region: test["municipio"].stringValue, address:test["direccion"].stringValue, capacity: test["cupo"].stringValue, dates: dates)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return testList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList[section].dates.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return testList[section].location
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestTableViewCell
        let test = testList[indexPath.section]
        let dateItem = test.dates[indexPath.row]
        cell.dateLabel.text = dateItem.formatedDate()
        cell.timeLabel.text = dateItem.formatedTimeRange()
        return cell
    }
}
