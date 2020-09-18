//
//  FAQTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 6/3/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    @IBOutlet var pregunta: UILabel!
    @IBOutlet var respuesta: UILabel!
    @IBOutlet var imagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
