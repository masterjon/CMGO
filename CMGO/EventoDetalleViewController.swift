//
//  EventoDetalleViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/2/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class EventoDetalleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var responsableLabel: UILabel!
    @IBOutlet weak var institucionLabel: UILabel!
    @IBOutlet weak var sedeLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var telBtn: UIButton!
    
    var evento : Evento!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = evento.nombre_evento
        responsableLabel.text = evento.nombre_solicitante
        institucionLabel.text = evento.nombre_institucion
        mailBtn.setTitle(evento.correo, for: .normal)
        telBtn.setTitle(evento.telefono, for: .normal)
        sedeLabel.text = "\(evento.estado), \(evento.municipio)"
        direccionLabel.text = evento.direccion
        fechaLabel.text = "\(evento.formatedDateStart()) - \(evento.formatedDateEnd())"
        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func openMail(_ sender: UIButton) {
        openUrl("mailto:\(sender.title(for: .normal) ?? "")")
    }
    
    @IBAction func openphone(_ sender: UIButton) {
        openUrl("tel:\(sender.title(for: .normal) ?? "")")
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
