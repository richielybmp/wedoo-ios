//
//  ToDooItemCell.swift
//  WeDoo
//
//  Created by Gean Delon on 13/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit

class ToDooItemCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
