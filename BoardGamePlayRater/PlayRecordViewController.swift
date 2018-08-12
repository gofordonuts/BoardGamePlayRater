//
//  PlayRecordViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 7/29/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class PlayRecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var imagePicker = UIImagePickerController()

    var game : Game? = nil
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var playerCountPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        playerCountPickerView.dataSource = self
        playerCountPickerView.delegate = self
        
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
    
}
