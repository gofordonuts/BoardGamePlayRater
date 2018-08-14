//
//  GameTableViewCell.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 8/14/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
