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
    case byDate, byTopic, byState, bySubTopic
}
class EventosViewController: UIViewController {

    var events = [Evento]()
    var temaParentList = [TemaParent]()
    var temaGrandParentList = [TemaGrandParent]()
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
        case .bySubTopic:
            loadingIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow{
//
//            switch listType! {
//            case .byTopic:
//                let temaGrandParent = temaGrandParentList[indexPath.row]
//                let vc = segue.destination as! EventosViewController
//                vc.listType = .bySubTopic
//                vc.title = temaGrandParent.title
//                vc.temaParentList = temaGrandParent.temaParents
//
//            case .byDate,.bySubTopic:
//                let item = temaParentList[indexPath.section].events[indexPath.row]
//                let vc = segue.destination as! EventoDetalleViewController
//                vc.evento = item
//            case .byState:
//                let item = stateList[indexPath.section].events[indexPath.row]
//                let vc = segue.destination as! EventoDetalleViewController
//                vc.evento = item
//            }
//
//
//
//        }
//    }
    
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
                for temaParent in json["msg"].arrayValue{
                    var temaParentList = [TemaParent]()
                    for tema in temaParent["temas"].arrayValue{
                        if let data = try? tema["eventos"].rawData(){
                            print(tema["eventos"])
                            if let e = try? JSONDecoder().decode([Evento].self, from: data){
                                let temaParent = TemaParent(title: tema["tema"].stringValue, events: e)
                                temaParentList.append(temaParent)
                            }
                        }
                    }
                    let temaGrandParent = TemaGrandParent(title: temaParent["nombre_especialidad"].stringValue, temaParents: temaParentList)
                    self.temaGrandParentList.append(temaGrandParent)
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

extension EventosViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch listType! {
        case .byTopic:
            return 1
        case .byDate,.bySubTopic:
            return temaParentList.count
        case .byState:
            return stateList.count
        
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch listType! {
        case .byTopic:
            return ""
        case .byDate,.bySubTopic:
            return temaParentList[section].title
        case .byState:
            return stateList[section].title
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType! {
        case .byTopic:
            if !temaGrandParentList.isEmpty{
                return temaGrandParentList.count
            }
            else{ return 0}
        case .byDate,.bySubTopic:
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
        
        let item:Any
        
        switch listType! {
        case .byTopic:
            item = temaGrandParentList[indexPath.row]
        case .byDate,.bySubTopic:
            item = temaParentList[indexPath.section].events[indexPath.row]
        case .byState:
            item = stateList[indexPath.section].events[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        if let item = item as? Evento{
            cell.titleLabel.text = item.nombre_evento
            cell.dateLabel.text = "\(item.formatedDateStart()) - \(item.formatedDateEnd())"
            cell.timeLabel.text = "\(item.estado), \(item.municipio ?? "")"
            cell.dateLabel.textColor = .black
        }
        else if let tema = item as? TemaGrandParent{
            cell.titleLabel.text = tema.title
            cell.timeLabel.text = ""
            cell.dateLabel.text = "Ver temas >"
            cell.dateLabel.textColor = ColorPalette.LightGreen
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch listType! {
        case .byTopic:
            let temaGrandParent = temaGrandParentList[indexPath.row]
            let vc = storyBoard.instantiateViewController(withIdentifier: "EventosVC") as! EventosViewController
            vc.listType = .bySubTopic
            vc.title = temaGrandParent.title
            vc.temaParentList = temaGrandParent.temaParents
            self.navigationController?.pushViewController(vc, animated: true)
        case .byDate,.bySubTopic:
            let item = temaParentList[indexPath.section].events[indexPath.row]
            let vc = storyBoard.instantiateViewController(withIdentifier: "EventoDetalleVC") as! EventoDetalleViewController
            vc.evento = item
            self.navigationController?.pushViewController(vc, animated: true)
        case .byState:
            let item = stateList[indexPath.section].events[indexPath.row]
            let vc = storyBoard.instantiateViewController(withIdentifier: "EventoDetalleVC") as! EventoDetalleViewController
            vc.evento = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
