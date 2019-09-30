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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recintoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = test.location
        dateLabel.text = test.formatedDate()
        timeLabel.text = test.formatedTimeRange()
        recintoLabel.text = test.region
        direccionLabel.text = test.address
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
