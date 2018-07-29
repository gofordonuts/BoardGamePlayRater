//
//  GameViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 7/20/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var minPlayerCountTextField: UITextField!
    @IBOutlet weak var maxPlayerCountTextField: UITextField!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var countStackView: UIStackView!
    
    var imagePicker = UIImagePickerController()
    var game : Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        // Add padding to stack views for cleaner look:
        titleStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        titleStackView.isLayoutMarginsRelativeArrangement = true
        countStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        countStackView.isLayoutMarginsRelativeArrangement = true
        
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
            // Create new game
            //trimmingCharacters(in: .whitespaces)
            if !(nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                
                // creates context for core data storing:
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let game = Game(context: context)
                
                // Save input data to game context here:
                game.name = nameTextField.text
                game.rating = 11.0
                if !(minPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                    game.minPlayerCount = Int16(minPlayerCountTextField.text!)!
                } else {
                    game.minPlayerCount = 0
                }
                if !(maxPlayerCountTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                    game.maxPlayerCount = Int16(maxPlayerCountTextField.text!)!
                } else {
                    game.maxPlayerCount = 0
                }
                game.image = UIImagePNGRepresentation(gameImageView.image!)
            
            } else {
                
                // If user has not provided board game name, present alert:
                
                let alert = UIAlertController(title: "Missing Information!", message: "Must provide a name for the board game before saving", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        gameImageView.image = image
        gameImageView.contentMode = .scaleToFill
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
