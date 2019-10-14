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

enum EventListDisplay {
    case byDate, byTopic, byState
}
class EventosViewController: UIViewController {

    var events = [Evento]()
    var temaParentList = [TemaParent]()
    var stateList = [TemaParent]()
    var listType: EventListDisplay!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        switch listType! {
        case .byDate:
            getEventsByDate()
        case .byState:
            getEvents(byState: true)
        case .byTopic:
            getEventsByTopic()
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let item:Evento
            switch listType! {
            case .byTopic,.byDate:
                item = temaParentList[indexPath.section].events[indexPath.row]
                
            case .byState:
                item = stateList[indexPath.section].events[indexPath.row]
            }
            let vc = segue.destination as! EventoDetalleViewController
            vc.evento = item
        }
    }
    
    func getEvents(byState:Bool=false){
        Alamofire.request("https://cmgo.org.mx/core/index.php/solicitud_puntaje/eventos_service/estado/", headers:getHttpHeaders()).validate().responseJSON { (response) in
            self.loadingIndicator.stopAnimating()
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let jsonData = try? json["msg"].rawData(){
                    if let e  = try? JSONDecoder().decode([Evento].self, from: jsonData){
                        self.events = e
                        if !byState{
                            self.tableView.reloadData()
                        }
                    }
                }
                if byState{
                    for event in self.events{
                        if self.stateList.isEmpty{
                            let state = TemaParent(title: event.estado, events: [event])
                            self.stateList.append(state)
                        }
                        else{
                            let index = self.stateList.firstIndex(where: { (item) -> Bool in
                                item.title == event.estado
                            })
                            if let index = index{
                                print("indexx")
                                self.stateList[index].events.append(event)
                            }
                            else{
                                let state = TemaParent(title: event.estado, events: [event])
                                self.stateList.append(state)
                            }
                        }
                    }
                    self.stateList = self.stateList.sorted(by: { $0.title < $1.title })
                    self.tableView.reloadData()
                }
                print(self.events)
                
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    func getEventsByTopic(){        Alamofire.request("https://cmgo.org.mx/core/index.php/solicitud_puntaje/Temas/contenido/", headers:getHttpHeaders()).validate().responseJSON { (response) in
        self.loadingIndicator.stopAnimating()
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                for tema in json["msg"].arrayValue{
                    if let data = try? tema["eventos"].rawData(){
                        print(tema["eventos"])
                        if let e = try? JSONDecoder().decode([Evento].self, from: data){
                            let temaParent = TemaParent(title: tema["tema"].stringValue, events: e)
                            self.temaParentList.append(temaParent)
                        }
                    }
                }
                self.tableView.reloadData()
                print(self.events)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    func getEventsByDate(){        Alamofire.request("https://cmgo.org.mx/core/index.php/solicitud_puntaje/eventos_service/contenido", headers:getHttpHeaders()).validate().responseJSON { (response) in
        self.loadingIndicator.stopAnimating()
        switch response.result{
        case .success(let value):
            let json = JSON(value)
            for tema in json["msg"].arrayValue{
                if let data = try? tema["eventos"].rawData(){
                    print(tema["eventos"])
                    if let e = try? JSONDecoder().decode([Evento].self, from: data){
                        let title = "\(tema["nombre_mes"].stringValue) \(tema["anio"].stringValue)"
                        let temaParent = TemaParent(title: title, events: e)
                        self.temaParentList.append(temaParent)
                    }
                }
            }
            self.tableView.reloadData()
            print(self.events)
            
        case .failure(let error):
            print(error)
            
        }
        }
    }
}

extension EventosViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch listType! {
        case .byTopic,.byDate:
            return temaParentList.count
        case .byState:
            return stateList.count
        
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch listType! {
        case .byTopic,.byDate:
            return temaParentList[section].title
        case .byState:
            return stateList[section].title
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType! {
        case .byTopic, .byDate:
            if !temaParentList.isEmpty{
                print("Tema count")
                return temaParentList[section].events.count
            }
            else{ return 0}
        case .byState:
            if !stateList.isEmpty{
                print("Tema count")
                return stateList[section].events.count
            }
            else{ return 0}
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item:Evento
        
        switch listType! {
        case .byTopic,.byDate:
            item = temaParentList[indexPath.section].events[indexPath.row]
            
        case .byState:
            item = stateList[indexPath.section].events[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.titleLabel.text = item.nombre_evento
        cell.dateLabel.text = "\(item.formatedDateStart()) - \(item.formatedDateEnd())"
        cell.timeLabel.text = "\(item.estado), \(item.municipio ?? "")"
        return cell
    }
    
    
}
