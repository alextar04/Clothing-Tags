//
//  TagDescriptionCell.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 03.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class TagDescriptionCell: UITableViewCell {

    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
