//
//  MenuTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 4/2/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet var titulo: UILabel!
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
