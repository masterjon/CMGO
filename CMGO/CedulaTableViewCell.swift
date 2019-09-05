//
//  CedulaTableViewCell.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/5/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

class CedulaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
