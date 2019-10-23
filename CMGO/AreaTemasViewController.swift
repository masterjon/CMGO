//
//  AreaTemasViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/22/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AreaTemasViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicato: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    var idTema : String!
    var events = [Evento]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
        // Do any additional setup after loading the view.
    }
    
    
    func getEvents(){        Alamofire.request("https://cmgo.org.mx/core/index.php/solicitud_puntaje/Temas/contenido/", headers:getHttpHeaders()).validate().responseJSON { (response) in
        self.loadingIndicato.stopAnimating()
        switch response.result{
        case .success(let value):
            let json = JSON(value)
            for temaParent in json["msg"].arrayValue{
                for tema in temaParent["temas"].arrayValue{
                    if tema["id_tema"].stringValue == self.idTema{
                        if let data = try? tema["eventos"].rawData(){
                            
                            if let e = try? JSONDecoder().decode([Evento].self, from: data){
                                
                                self.events = e
                            }
                        }
                    }
                }
            }
            print("effff")
            self.tableView.reloadData()
            if self.events.isEmpty{
                self.errorLabel.text = "No hay próximos eventos disponibles con este tema"
                self.errorLabel.isHidden = false
            }
            
        case .failure(let error):
            print(error)
            
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let item = events[indexPath.row]
            let vc = segue.destination as! EventoDetalleViewController
            vc.evento = item
        }
    }

}

extension AreaTemasViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        let item = events[indexPath.row]
        print(item)
        cell.titleLabel.text = item.nombre_evento
        cell.dateLabel.text = "\(item.formatedDateStart()) - \(item.formatedDateEnd())"
        cell.timeLabel.text = "\(item.estado), \(item.municipio ?? "")"
        return cell
    }
    
    
}

