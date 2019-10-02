//
//  EventosViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/27/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventosViewController: UIViewController {

    var events = [Evento]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getRemoteEvents()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let evento = events[indexPath.row]
            let vc = segue.destination as! EventoDetalleViewController
            vc.evento = evento
        }
    }
    
    func getRemoteEvents(){
        print("getemotevents")

    Alamofire.request("https://cmgo.org.mx/core/index.php/solicitud_puntaje/eventos_service/contenido", headers:getHttpHeaders()).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let jsonData = try? json["msg"].rawData(){
                    if let e  = try? JSONDecoder().decode([Evento].self, from: jsonData){
                        self.events = e
                        self.tableView.reloadData()
                    }
                }
                print(self.events)
                
            case .failure(let error):
                print(error)
                
            }
            
        }
    }

}

extension EventosViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.titleLabel.text = "\(item.estado), \(item.municipio)"
        cell.dateLabel.text = "\(item.formatedDateStart()) - \(item.formatedDateEnd())"
        cell.timeLabel.text = ""
        return cell
    }
    
    
}
