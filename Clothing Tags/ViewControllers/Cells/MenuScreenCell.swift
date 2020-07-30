//
//  MenuScreenTableCell.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 30.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class MenuScreenCell: UITableViewCell {
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var imageAction: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
