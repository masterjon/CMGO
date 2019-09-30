//
//  MenuViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/30/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let items = [
        ["icon":"P5-R1", "title":"Inicio", "vc":"InicioNVC"],
        ["icon":"P5-R3", "title":"Eventos con puntaje", "vc":"EventosNVC"],
        ["icon":"P5-R4", "title":"Mi agenda", "vc":"MiAgendaNVC"],
        ["icon":"P5-R5", "title":"Examen de Certificación", "vc":"ExamenNVC"],
        ["icon":"P5-R7", "title":"Vigencia de Certificación", "vc":"VigenciaNVC"],
        ["icon":"P5-R8", "title":"Médicos Certificados", "vc":"MedicosNVC"],
        ["icon":"P5-R9", "title":"Noticias", "vc":"NoticiasNVC"],
        ["icon":"P5-R10", "title":"Contactos", "vc":"ContactoNVC"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let img = cell.viewWithTag(1) as? UIImageView{
            img.image = UIImage(named: items[indexPath.row]["icon"]!)
        }
        if let label = cell.viewWithTag(2) as? UILabel{
            label.text = items[indexPath.row]["title"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vcTitle = items[indexPath.row]["vc"] else{return}
        let nvc = self.storyboard!.instantiateViewController(withIdentifier: vcTitle)
        present(nvc, animated: false, completion: nil)
    }
    
    
}
