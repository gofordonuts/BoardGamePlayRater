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
    var game : Game? = nil
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var playerCountPickerView: UIPickerView!
    @IBOutlet weak var playTrackTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        playerCountPickerView.dataSource = self
        playerCountPickerView.delegate = self
        
        playTrackTableView.delegate = self
        playTrackTableView.dataSource = self
        
        playTrackTableView.layer.borderWidth = 1.0
        playTrackTableView.tableFooterView = UIView(frame: CGRect.zero)
        playTrackTableView.isScrollEnabled = true
        
        if game != nil {
            gameNameLabel.text = game!.name
           /* playerCountPickerView.numberOfComponents(game!.maxPlayerCount - game!.minPlayerCount
             */
        } else {
            print("game is nil")
        }
        gameImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
     /*
     alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
     
     
     self.present(alert, animated: true)
     imagePicker.sourceType = .photoLibrary
     
     present(imagePicker, animated: true, completion: nil)
     */
     
 /*********** PLAYER COUNT PICKER VIEW SETUP **************/
 
    
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "<Your Font Name>", size: <Font Size>)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = <Data Array>[row]
        pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }

    */
    
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
    
    
    // Functions for TableView with date picker and ratings:
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "dateLabelProtoCell"), for: indexPath) as! DateLabelTableViewCell
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            (playTrackTableView.cellForRow(at: indexPath) as! DateLabelTableViewCell).setDatePickerStackViewHidden()
            //playTrackTableView.estimatedRowHeight = 60
            playTrackTableView.rowHeight = UITableViewAutomaticDimension
            playTrackTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        playTrackTableView.deselectRow(at: indexPath, animated: true)
    }
 
}
