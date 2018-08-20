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
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playerInfoButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var playerTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var doneButton: UIButton!
    
    //Parameters for detail view height:
    //let detailViewHeightInitial: CGFloat = 140
    
    // Parameters for hiding and showing date picker:
    var datePickerOpened: Bool = false    // state variable
    var datePickerHeightOpened: CGFloat!
    let datePickerHeightClosed: CGFloat = 0
    let datePickerMarginTopOpened: CGFloat = 0  // 18 (see below)
    let datePickerMarginTopClosed: CGFloat = 0
    let animateTimeStd: TimeInterval = 0.5
    let animateTimeZero: TimeInterval = 0.0
    
    // Parameters for hiding and showing players table:
    var playerTableOpened: Bool = false    // state variable
    var playerTableHeightOpened: CGFloat!
    let playerTableHeightClosed: CGFloat = 0
    let playerTableMarginTopOpened: CGFloat = 0  // 18 (see below)
    let playerTableMarginTopClosed: CGFloat = 0
    
    var numberOfPlayersAdded : Int = 0
    
    // Parameters for hiding and showing rating view:
    var ratingViewOpened: Bool = false    // state variable
    var ratingViewHeightOpened: CGFloat!
    let ratingViewHeightClosed: CGFloat = 0
    let ratingViewMarginTopOpened: CGFloat = 0  // 18 (see below)
    let ratingViewMarginTopClosed: CGFloat = 0
    
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
        
        detailViewHeight.constant = 100.0
        
/****** Date Picker initialization: ********/
        datePicker.datePickerMode = UIDatePickerMode.date
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "MMM  dd,   yyyy"
        datePicker.isHidden = !datePickerOpened
        datePickerHeight.constant = datePickerHeightClosed
        let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
       
/****** Player Table View initialization: ********/
        playerTableView.dataSource  = self
        playerTableView.delegate = self
        playerTableView.isHidden = !playerTableOpened
        playerTableHeight.constant = playerTableHeightClosed
      
/****** Rating View initialization: ********/
        ratingView.isHidden = !ratingViewOpened
        ratingViewHeight.constant = ratingViewHeightClosed
        
/****** Intial setup of Buttons: ******/
        
        // Date button:
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        dateButton.setTitle("Date:      \(initialDate)", for: .normal)
        dateButton.layer.borderWidth = 1.0
        dateButton.layer.borderColor = UIColor.blue.cgColor
        dateButton.layer.cornerRadius = 8.0
        
        // Player Information button:
        playerInfoButton.layer.borderWidth = 1.0
        playerInfoButton.layer.borderColor = UIColor.blue.cgColor
        playerInfoButton.layer.cornerRadius = 8.0
        playerInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        
        // Rating button:
        ratingButton.layer.borderWidth = 1.0
        ratingButton.layer.borderColor = UIColor.blue.cgColor
        ratingButton.layer.cornerRadius = 8.0
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        ratingView.layer.borderWidth = 1.0 
/****** Allow user interaction: ********/
        gameImageView.isUserInteractionEnabled = true
   
        
    }
    
    override func viewDidLayoutSubviews() {
        // set space to expand AFTER device arranges the subviews to accommodate screen size
        let emptySpaceToExpand = doneButton.frame.origin.y - (detailView.frame.origin.y + 110.0)
        datePickerHeightOpened = emptySpaceToExpand
        playerTableHeightOpened = emptySpaceToExpand
        ratingViewHeightOpened = emptySpaceToExpand
    }
    
/******** UIViewController Buttons: **********/
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
        // first close other submenus if open
        if (playerTableOpened) {
            showPlayerTable(show: !playerTableOpened, animateTime: animateTimeZero)
        }
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
        // first close other submenus if open
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
        // first close other subviews if open
        if (datePickerOpened) {
            let initialDate = dateFormatter?.string(from: datePicker.date) ?? "N/A"
            dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            dateButton.setTitle("Date:      \(initialDate)", for: .normal)
            showDatePicker(show: !datePickerOpened, animateTime: animateTimeZero)
        }
        if (playerTableOpened) {
            showPlayerTable(show: !playerTableOpened, animateTime: animateTimeZero)
        }
        // Display rating view:
        if (ratingViewOpened) {
            showRatingView(show: !ratingViewOpened, animateTime: animateTimeZero)
        } else {
            showRatingView(show: !ratingViewOpened, animateTime: animateTimeZero)
        }
    }
    
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
            self.detailViewHeight.constant = (show ? (100.0 + self.datePickerHeightOpened) : 100.0)
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
            self.detailViewHeight.constant = (show ? (100.0 + self.playerTableHeightOpened) : 100.0)
            self.playerTableHeight.constant = (show ? self.playerTableHeightOpened : self.playerTableHeightClosed)
            //self.datePickerMarginTop.constant = (show ? self.datePickerMarginTopOpened : self.datePickerMarginTopClosed)
            
            // Update view:
            self.view.layoutIfNeeded()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = 0
        if (numberOfPlayersAdded == 0) {
            numOfRows = 1
        } else {
            let count : Int16 = (game?.maxPlayerCount)!
            if (numberOfPlayersAdded < Int(count)) {
                numOfRows = numberOfPlayersAdded + 1
            } else {
                numOfRows = Int(count)
            }
        }
        
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let count : Int16 = (game?.maxPlayerCount)!
        if (numberOfPlayersAdded < Int(count)) {
            if (indexPath.row == (tableView.numberOfRows(inSection: 0) - 1)) {
                cell.textLabel?.text = "+   "
            } else {
                let playerNumber = indexPath.row + 1
                cell.textLabel?.text = "Player \(playerNumber)"
            }
        } else {
            // Need to get player info here:
            let playerNumber = indexPath.row + 1
            cell.textLabel?.text = "Player \(playerNumber)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.textLabel?.text == "+   ") {
            performSegue(withIdentifier: "PlayerInformationSegue", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /*********** RATING VIEW **************/
    func showRatingView(show: Bool, animateTime: TimeInterval) {
        // set state variable
        ratingViewOpened = show
        
        self.ratingView.isHidden = !show
        UIView.animate(withDuration: animateTime, animations: {
            // toggle open/close the rating UIView
            self.ratingViewHeight.constant = (show ? (100.0 + self.ratingViewHeightOpened) : 100.0)
            self.ratingViewHeight.constant = (show ? self.playerTableHeightOpened : self.ratingViewHeightClosed)
            
            // Update view:
            self.view.layoutIfNeeded()
        })
    }
    
}
