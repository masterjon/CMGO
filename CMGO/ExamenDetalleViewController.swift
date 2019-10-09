//
//  ExamenDetalleViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/4/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class ExamenDetalleViewController: UIViewController {

    var test:Test!
    var date:TestDate!
    var showAgenda = true
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recintoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var cupoLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var agendaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = test.sede
        dateLabel.text = test.formatedDate()
        timeLabel.text = test.formatedTimeRange()
        recintoLabel.text = test.sede
        direccionLabel.text = test.direccion
        cupoLabel.text = test.cupo
        agendaBtn.isHidden = !showAgenda
    }

    @IBAction func addEvent(_ sender: UIButton) {
        let (_,msg) = addMyTests(item: test)
        present(alertDefault(title: msg),animated: true)
    }

}
