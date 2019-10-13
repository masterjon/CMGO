//
//  EventoDetalleViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/2/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class EventoDetalleViewController: UIViewController {

    @IBOutlet weak var agendaBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var responsableLabel: UILabel!
    @IBOutlet weak var institucionLabel: UILabel!
    @IBOutlet weak var sedeLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var telBtn: UIButton!
    @IBOutlet weak var temasStackView: UIStackView!
    let networkManager = NetworkManager()
    var evento : Evento!
    var temas = [Tema]()
    var showAgenda = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = evento.nombre_evento
        responsableLabel.text = evento.nombre_solicitante
        institucionLabel.text = evento.nombre_institucion
        mailBtn.setTitle(evento.correo, for: .normal)
        telBtn.setTitle(evento.telefono, for: .normal)
        sedeLabel.text = "\(evento.estado), \(evento.municipio ?? "")"
        direccionLabel.text = evento.direccion
        fechaLabel.text = "\(evento.formatedDateStart()) - \(evento.formatedDateEnd()) \(evento.formatedYear())"
        // Do any additional setup after loading the view.
        agendaBtn.isHidden = !showAgenda
        if let t = evento?.temas{
            temas = t
            populateTemas()
        }
        else{
            networkManager.getEvent(id: evento!.id_evento) { (eventR) in
                if let t = eventR?.temas{
                    self.temas = t
                    self.populateTemas()
                }
            }
        }
    }
    
    func populateTemas(){
        
        for tema in temas{
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            label.text = "• \(tema.tema)"
            temasStackView.addArrangedSubview(label)
        }
    }
    
 
    @IBAction func openMail(_ sender: UIButton) {
        openUrl("mailto:\(sender.title(for: .normal) ?? "")")
    }
    
    @IBAction func openphone(_ sender: UIButton) {
        openUrl("tel:\(sender.title(for: .normal) ?? "")")
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        let (_,msg) = addMyEvent(item: evento)
        present(alertDefault(title: msg),animated: true)
    }
    

}
