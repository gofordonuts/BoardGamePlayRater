//
//  PlayRecordViewController.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 7/29/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class PlayRecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var imagePicker = UIImagePickerController()
    var dateFormatter : DateFormatter?
    var game : Game? = nil
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var playerCountPickerView: UIPickerView!
    
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playerInfoButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var playerTableHeight: NSLayoutConstraint!
    
    
    // Parameters for hiding and showing date picker:
    var datePickerOpened: Bool = false    // state variable
    let datePickerHeightOpened: CGFloat = 214
    let datePickerHeightClosed: CGFloat = 0
    let datePickerMarginTopOpened: CGFloat = 0  // 18 (see below)
    let datePickerMarginTopClosed: CGFloat = 0
    let animateTimeStd: TimeInterval = 0.5
    let animateTimeZero: TimeInterval = 0.0
    
    // Parameters for hiding and showing players table:
    var playerTableOpened: Bool = false    // state variable
    let playerTableHeightOpened: CGFloat = 214
    let playerTableHeightClosed: CGFloat = 0
    let playerTableMarginTopOpened: CGFloat = 0  // 18 (see below)
    let playerTableMarginTopClosed: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

/****** Player Count Picker initialization: *******/
        imagePicker.delegate = self
        playerCountPickerView.dataSource = self
        playerCountPickerView.delegate = self

/****** Load any existing game data to present here: *******/
        if game != nil {
            gameNameLabel.text = game!.name
           /* playerCountPickerView.numberOfComponents(game!.maxPlayerCount - game!.minPlayerCount
             */
        } else {
            print("game is nil")
        }

/****** Date Picker initialization: ********/
        datePicker.datePickerMode = UIDatePickerMode.date
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "MMM  dd,   yyyy"
        datePicker.isHidden = !datePickerOpened
        datePickerHeight.constant = datePickerHeightClosed
        let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
       
/****** Intial setup of Buttons: ******/
        
        // Date button:
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        dateButton.setTitle("Date:      \(initialDate)", for: .normal)
        dateButton.layer.borderWidth = 1.0
        dateButton.layer.borderColor = UIColor.black.cgColor
        dateButton.layer.cornerRadius = 8.0
        
        // Player Information button:
        playerInfoButton.layer.borderWidth = 1.0
        playerInfoButton.layer.borderColor = UIColor.black.cgColor
        playerInfoButton.layer.cornerRadius = 8.0
        playerInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        
        // Rating button:
        ratingButton.layer.borderWidth = 1.0
        ratingButton.layer.borderColor = UIColor.black.cgColor
        ratingButton.layer.cornerRadius = 8.0
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        
/****** Allow user interaction: ********/
        gameImageView.isUserInteractionEnabled = true
   
        
    }
    

/******** UIViewController Buttons: **********/
    @IBAction func doneTapped(_ sender: Any) {
        // Save game play here:
        let playerCount = Int16(playerCountPickerView.selectedRow(inComponent: 0)) + (game?.minPlayerCount)!
        // let playDate = playDatePickerView.date
        
        print("Player Count = \(playerCount)")
        //print("Play date = \(playDate)")
        
        
        self.dismiss(animated: true) {
            //dismiss code goes here
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            //dismiss code goes here
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
     
        if sender.state == .ended {      // Move the view down and to the right when tapped.
            // Select existing image to use for board game
     
            let alert = UIAlertController(title: "Select image source", message: "Where do you want to get the image from?", preferredStyle: .alert)
     
            alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Use photo library"), style: .default, handler: { _ in
                // Alert action for selecting Photo Library to obtain photo:
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    // If photo library is accessible, present photo library to select image
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    // If photo library is not accessible, then present alert to user:
                    let alert = UIAlertController(title: "No access to photo library!", message: "You have no access to any photo library, and cannot select a photo", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Use camera"), style: .default, handler: { _ in
                // Alert action for selecting Camera to obtain photo:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    // If camera is accessible, present photo library to select image
                    self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    // If camera is not accessible, then present alert to user:
                    let alert = UIAlertController(title: "Camera not available!", message: "You have no access to any camera for obtaining an image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }))
     
            self.present(alert, animated: true, completion: nil)
     
        }
    }
    
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        if (datePickerOpened) {
            let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
            dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            dateButton.setTitle("Date:      \(initialDate)", for: .normal)
            showDatePicker(show: !datePickerOpened, animateTime: animateTimeZero)
        } else {
            showDatePicker(show: !datePickerOpened, animateTime: animateTimeStd)
        }
    }
    
    
    @IBAction func playerInfoButtonTapped(_ sender: Any) {
        // first close date picker if open
        if (datePickerOpened) {
            let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
            dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            dateButton.setTitle("Date:      \(initialDate)", for: .normal)
            showDatePicker(show: !datePickerOpened, animateTime: animateTimeZero)
        }
        // Display list of players
        if (playerTableOpened) {
            showPlayerTable(show: !playerTableOpened, animateTime: animateTimeZero)
        } else {
            showPlayerTable(show: !playerTableOpened, animateTime: animateTimeStd)
        }
    }
    
    @IBAction func ratingButtonTapped(_ sender: Any) {
        // first close date picker if open
        if (datePickerOpened) {
            let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
            dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            dateButton.setTitle("Date:      \(initialDate)", for: .normal)
            showDatePicker(show: !datePickerOpened, animateTime: animateTimeZero)
        }
    }
    
    /*********** PLAYER COUNT PICKER VIEW SETUP **************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = game!.maxPlayerCount - game!.minPlayerCount
        return Int(count) + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(game!.minPlayerCount + Int16(row))
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        gameImageView.image = image
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    

    
/*********** DATE PICKER WITH LABEL **************/
    func showDatePicker(show: Bool, animateTime: TimeInterval) {
        // set state variable
        datePickerOpened = show
        
        // this makes the datePicker disappear from the screen BUT leaves the space still occupied
        // this is not strictly necessary but it will make the appearance more tidy
        self.datePicker.isHidden = !show

        // animate the datePicker open/hide - this is the where the constraints are modified
        UIView.animate(withDuration: animateTime, animations: {
            // toggle open/close the datePicker

            self.datePickerHeight.constant = (show ? self.datePickerHeightOpened : self.datePickerHeightClosed)
            //self.datePickerMarginTop.constant = (show ? self.datePickerMarginTopOpened : self.datePickerMarginTopClosed)

            // Update view:
            self.view.layoutIfNeeded()
        })
    }

/*********** PLAYER TABLE VIEW **************/
    func showPlayerTable(show: Bool, animateTime: TimeInterval) {
        // set state variable
        playerTableOpened = show
        
        // this makes the datePicker disappear from the screen BUT leaves the space still occupied
        // this is not strictly necessary but it will make the appearance more tidy
        //self.datePicker.isHidden = !show
        self.playerTableView.isHidden = !show
        // animate the datePicker open/hide - this is the where the constraints are modified
        UIView.animate(withDuration: animateTime, animations: {
            // toggle open/close the datePicker
            
            self.playerTableHeight.constant = (show ? self.playerTableHeightOpened : self.playerTableHeightClosed)
            //self.datePickerMarginTop.constant = (show ? self.datePickerMarginTopOpened : self.datePickerMarginTopClosed)
            
            // Update view:
            self.view.layoutIfNeeded()
        })
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
