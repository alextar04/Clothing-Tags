//
//  ReminderTableScreen.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class ReminderTableCell: UITableViewCell {

    @IBOutlet weak var imageClothes: UIImageView!
    @IBOutlet weak var nameClothes: UILabel!
    @IBOutlet weak var dateLaundry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
