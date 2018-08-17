//
//  DateLabelTableViewCell.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 8/15/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class DateLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var datePickerStackView: UIStackView!
    @IBOutlet weak var cellStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //UIDatePicker and Date Label:
        dateLabel.text = "Date:"
        datePicker.setDate(Date(), animated: false)
        datePickerLabel.text = "\(datePicker.date)"
        
        datePickerStackView.isHidden = true
        labelStackView.isHidden = false
    }
    
    func setDatePickerStackViewHidden() {
        datePickerStackView.isHidden = false
        datePickerStackView.frame.size = CGSize(width: datePickerStackView.frame.width, height: 150)
        
        labelStackView.isHidden = true
        labelStackView.frame.size = CGSize(width: datePickerStackView.frame.width, height: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
