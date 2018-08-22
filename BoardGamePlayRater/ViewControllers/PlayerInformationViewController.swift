//
//  PlayerInformationViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 8/20/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class PlayerInformationViewController: UIViewController {

    var game : Game? = nil
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var firstPlaceSwitch: UISwitch!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var playerInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGray
        playerInfoView.layer.cornerRadius = 8

        notesTextField.layer.cornerRadius = 8
        notesTextField.layer.borderWidth = 1
        notesTextField.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        
        if (game != nil) {
            gameNameLabel.text = game?.name
        }
    }
    
    @IBAction func existingPlayerButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    
}
