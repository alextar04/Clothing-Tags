//
//  categoryScreenCell.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 31.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit

class CategoryScreenCell: UITableViewCell {

    @IBOutlet weak var photoClothes: UIImageView!
    @IBOutlet weak var nameClothes: UILabel!
    @IBOutlet weak var tagsCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
