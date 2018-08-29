//
//  GameViewController.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 7/20/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var minPlayerCountTextField: UITextField!
    @IBOutlet weak var maxPlayerCountTextField: UITextField!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var countStackView: UIStackView!
    @IBOutlet weak var initialRatingStackView: UIStackView!
    @IBOutlet weak var initialRatingTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var game : Game? = nil
    
    var imageSetByUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        // Add padding to stack views for cleaner look:
        titleStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        titleStackView.isLayoutMarginsRelativeArrangement = true
        countStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        countStackView.isLayoutMarginsRelativeArrangement = true
        initialRatingStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        initialRatingStackView.isLayoutMarginsRelativeArrangement = true
        
        nameTextField.delegate = self
        initialRatingTextField.delegate = self
        minPlayerCountTextField.delegate = self
        maxPlayerCountTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: Notification.Name("initialRatingTextFieldShowKeyboard"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: Notification.Name("initialRatingTextFieldHideKeyboard"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
       // NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        if game != nil {
            nameTextField.text = game!.name
            minPlayerCountTextField.text = String(game!.minPlayerCount)
            maxPlayerCountTextField.text = String(game!.maxPlayerCount)
        } else {
            
        }
        
        gameImageView.isUserInteractionEnabled = true
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
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { _ in
                // Alert action for selecting Photo Library to obtain photo:
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            /*
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            
            self.present(alert, animated: true)
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
            */
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if game != nil {
            // Update old game
            game!.name = nameTextField.text
        } else {
            // Create new game but first check user has entered values:
            let nameInputIsEmpty = (nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
            let minPlayerInputIsEmpty =  (minPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
            let maxPlayerInputIsEmpty = (maxPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
            
            if nameInputIsEmpty {
                // If user has not provided board game name, present alert and cancel save:
                let alert = UIAlertController(title: "Missing Information!", message: "Must provide a name for the board game before saving", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if minPlayerInputIsEmpty || maxPlayerInputIsEmpty {
                // Check to see if user has input player counts and show alerts if not:

                // If user has not entered one or both player counts, present alert:
                var titleText = ""
                var messageText = ""
                if minPlayerInputIsEmpty && maxPlayerInputIsEmpty {
                    titleText = "Continue without setting Player Count values?"
                    messageText = "If no values are provided, default will be set to 1 - 100 players"
                } else if minPlayerInputIsEmpty {
                    titleText = "Continue without setting minimum Player Count?"
                    messageText = "If no value is provided, default minimum count will be set to 1 player"
                } else if maxPlayerInputIsEmpty{
                    titleText = "Continue without setting maximum Player Count?"
                    messageText = "If no value is provided, default maximum count will be set to 100 players"
                } else {
                    titleText = "ERROR!!!"
                    messageText = "Try again, and if still not working, contact developer"
                }
                
                let playerCountAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
                    
                playerCountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                playerCountAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                    // creates context for core data storing:
                    self.saveContextInCoreData()
                }))
                self.present(playerCountAlert, animated: true)
                    
            } else {
                // If user has entered name and both player count values, continue to save Core Data:
                self.saveContextInCoreData()
            }
        }
    }
    
    func saveContextInCoreData() {
        // Saves data to CoreData and pops UIViewController
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let game = Game(context: context)
        
        // Save input data to game context here:
        game.name = nameTextField.text
        game.rating = 11.0
        if !(minPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            game.minPlayerCount = Int16(minPlayerCountTextField.text!)!
        } else {
            game.minPlayerCount = 1
        }
        
        if !(maxPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            game.maxPlayerCount = Int16(maxPlayerCountTextField.text!)!
        } else {
            game.maxPlayerCount = 100
        }
        if self.imageSetByUser {
            game.image = UIImagePNGRepresentation(gameImageView.image!)
        } else {
            game.image = nil
        }
        
        if (initialRatingTextField.text?.isEmpty)! {
            game.rating = 11.0
            print("we are here")
        } else {
            let userRatingVal = Double(initialRatingTextField.text!.trimmingCharacters(in: .whitespaces))
            print("USer val ===== \(String(describing: userRatingVal))")
            let minVal : Double = 0.0
            let maxVal : Double = 10.0
            if  (minVal.isLessThanOrEqualTo(userRatingVal!)) && (userRatingVal!.isLessThanOrEqualTo(maxVal)) {
                game.rating = userRatingVal!
            } else {
                game.rating = 11.0
            }
        }
        
        if game.minPlayerCount > game.maxPlayerCount {
            let countAlert = UIAlertController(title: "Player Count not possible!", message: "Maximum player count must be greater than or equal to minimum player count", preferredStyle: .alert)
            countAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(countAlert, animated: true)
        } else {
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        gameImageView.image = image
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
        imageSetByUser = true
        imagePicker.dismiss(animated: true, completion: nil)
    }

/************** TEXTFIELD AND KEYBOARD FUNCTIONS *************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == initialRatingTextField) {
            NotificationCenter.default.post(name: Notification.Name("initialRatingTextFieldShowKeyboard"), object: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == initialRatingTextField) {
            NotificationCenter.default.post(name: Notification.Name("initialRatingTextFieldHideKeyboard"), object: nil)
        }
    }
    
    //Textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == initialRatingTextField) {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ".":
                let array = Array(textField.text!)
                var decimalCount = 0
                for character in array {
                    if character == "." {
                        decimalCount = decimalCount + 1
                    }
                }
                
                if decimalCount == 1 {
                    return false
                } else {
                    return true
                }
            default:
                let array = Array(string)
                if array.count == 0 {
                    return true
                }
                return false
            }
        } else {
            return true
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = self.view.frame.origin.y - 50 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
}
