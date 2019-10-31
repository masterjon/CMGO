//
//  MiAgendaViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/8/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

struct AgendaItem{
    let title:String
    var items:[Any]
}
class MiAgendaViewController: UIViewController {

    var myTests = [Test]()
    var myEvents = [Evento]()
    var agenda = [AgendaItem]()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        if let t = getMyTests(){
            myTests.append(contentsOf: t)
            if !myTests.isEmpty{
                let agendaItem = AgendaItem(title: "Examenes", items: myTests)
                agenda.append(agendaItem)
            }
            
        }
        if let e = getMyEvents(){
            myEvents.append(contentsOf: e)
            if !myEvents.isEmpty{
                let agendaItem = AgendaItem(title: "Eventos", items: myEvents)
                agenda.append(agendaItem)
            }
            
        }
        tableView.reloadData()
        if agenda.isEmpty{
            errorLabel.isHidden = false
            errorLabel.text = "Usted aún no ha añadido próximos Eventos con puntaje o Examenes"
        }
        
    }
}
extension MiAgendaViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return agenda.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agenda[section].items.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return agenda[section].title
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestTableViewCell
        
        if let item = agenda[indexPath.section].items[indexPath.row] as? Evento{
            cell.titleLabel.text = item.nombre_evento
            cell.dateLabel.text = "\(item.formatedDateStart()) - \(item.formatedDateEnd())"
            cell.timeLabel.text = "\(item.estado), \(item.municipio ?? "")"
            
        }
        else if let item = agenda[indexPath.section].items[indexPath.row] as? Test{
            cell.titleLabel.text = item.sede
            cell.dateLabel.text = item.formatedDate()
            cell.timeLabel.text = item.formatedTimeRange()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = agenda[indexPath.section].items[indexPath.row] as? Evento{
            let vc = storyboard!.instantiateViewController(withIdentifier: "EventoDetalleVC") as! EventoDetalleViewController
            vc.evento = item
            vc.showAgenda = false
            navigationController?.pushViewController(vc, animated: true)
        }
        else if let item = agenda[indexPath.section].items[indexPath.row] as? Test{
            let vc = storyboard!.instantiateViewController(withIdentifier: "ExamenDetalleVC") as! ExamenDetalleViewController
            vc.test = item
            vc.showAgenda = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            if let item = agenda[indexPath.section].items[indexPath.row] as? Evento{
                deleteMyEvent(item: item)
                deletePendingNotif(identifier:"event-\(item.id_evento)--3")
                deletePendingNotif(identifier:"event-\(item.id_evento)--30")
            }
            else if let item = agenda[indexPath.section].items[indexPath.row] as? Test{
                deleteMyTest(item: item)
                deletePendingNotif(identifier:"examen-\(item.id_sede)--3")
                deletePendingNotif(identifier:"examen-\(item.id_sede)--30")
                
            }
            agenda[indexPath.section].items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
            
//            for (idx,item) in storedCats.enumerated(){
//                if item[1] == row.id{
//                    deleteIndex = idx
//                }
//            }
//            if let i = deleteIndex{
//                storedCats.remove(at: i)
//                userDefaults.set(storedCats, forKey: "my_schedule_comegoC")
//                userDefaults.synchronize()
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                mylist[indexPath.section].remove(at: indexPath.row)
//                tableView.endUpdates()
//            }
        }
    }
    
    
}
