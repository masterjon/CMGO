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
    @IBOutlet weak var contactoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    var evento : Evento!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "\(evento.estado), \(evento.municipio)"
        responsableLabel.text = evento.nombre_solicitante
        institucionLabel.text = evento.nombre_institucion
        contactoLabel.text = evento.correo
        direccionLabel.text = evento.direccion
        fechaLabel.text = "\(evento.formatedDateStart()) - \(evento.formatedDateEnd())"
        // Do any additional setup after loading the view.
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
