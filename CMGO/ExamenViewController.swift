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
                    let json = JSON(value)
                    print("json")
                    for item in json["msg"].arrayValue{
                        if let jsonData = try? item.rawData(){
                            if let e  = try? JSONDecoder().decode(Test.self, from: jsonData){
                                if e.id_sede != "64"{
                                    self.testList.append(e)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                
            }
            
        }
    }

    @IBAction func openLink(_ sender: UIButton) {
        openUrl("https://cmgo.org.mx/requisitos-gyo.html")
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
        cell.titleLabel.text = test.sede
        cell.dateLabel.text = test.formatedDate()
        cell.timeLabel.text = test.formatedTimeRange()
        return cell
    }
}
