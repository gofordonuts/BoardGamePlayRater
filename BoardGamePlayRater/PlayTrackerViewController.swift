//
//  PlayTrackerViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 7/22/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class PlayTrackerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var trackGamePlayButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var game : Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        deleteButton.isHidden = true
        trackGamePlayButton.isHidden = false
        
        trackGamePlayButton.layer.borderWidth = 1.0
        trackGamePlayButton.layer.borderColor = UIColor.blue.cgColor
        trackGamePlayButton.layer.cornerRadius = 8.0
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        if game != nil {
            gameImageView.image = UIImage(data: game!.image! )
            gameImageView.contentMode = .scaleAspectFill
            gameImageView.clipsToBounds = true
            
            self.title = game!.name
            // Add drop shadow to gameRatingLabel:
            gameRatingLabel.layer.shadowColor = UIColor.black.cgColor
            gameRatingLabel.layer.shadowRadius = 3.0
            gameRatingLabel.layer.shadowOpacity = 1.0
            gameRatingLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
            gameRatingLabel.layer.masksToBounds = false
            
            ratingColor(rating: game!.rating)
            
            if game!.rating <= 10.0 {
                gameRatingLabel.text = String(game!.rating)
            } else {
                gameRatingLabel.text = "N/A"
            }
            
        } else {
            gameRatingLabel.text = "N/A"
            gameRatingLabel.backgroundColor = UIColor.lightGray
        }
    }

    func ratingColor(rating : Double) {
        if  rating >= 0.0 && rating < 1.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 204/255, green: 0, blue: 0, alpha: 0.5)
        } else if rating >= 1.0 && rating < 2.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        } else if rating >= 2.0 && rating < 3.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 1, green: 51/255, blue: 153/255, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 1, green: 51/255, blue: 153/255, alpha: 0.5)
        } else if rating >= 3.0 && rating < 4.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 1, green: 153/255, blue: 1, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 1, green: 153/255, blue: 1, alpha: 0.5)
        } else if rating >= 4.0 && rating < 5.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 1, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 1, alpha: 0.5)
        } else if rating >= 5.0 && rating < 6.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 204/255, green: 153/255, blue: 1, alpha: 1)
             gameImageView.backgroundColor = UIColor(red: 204/255, green: 153/255, blue: 1, alpha: 0.5)
        } else if rating >= 6.0 && rating < 7.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 153/255, green: 1, blue: 1, alpha: 1)
             gameImageView.backgroundColor = UIColor(red: 153/255, green: 1, blue: 1, alpha: 0.5)
        } else if rating >= 7.0 && rating < 8.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 153/255, green: 1, blue: 153/255, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 153/255, green: 1, blue: 153/255, alpha: 0.5)
        } else if rating >= 8.0 && rating < 9.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 102/255, green: 204/255, blue: 102, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 102/255, green: 204/255, blue: 102, alpha: 0.5)
        } else if rating >= 9.0 && rating < 10.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 0, green: 204, blue: 0, alpha: 1)
            gameImageView.backgroundColor = UIColor(red: 0, green: 204, blue: 0, alpha: 0.5)
        } else if rating == 10.0 {
            gameRatingLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
             gameImageView.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        } else {
            gameRatingLabel.backgroundColor = UIColor.lightGray
            gameImageView.backgroundColor = UIColor.lightGray
        }
    }
    
    

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            // user just tapped the Edit button (it now says Done)
            deleteButton.isHidden = false
            trackGamePlayButton.isHidden = true
        } else {
            // user just tapped the Done button (it now says Edit)
            deleteButton.isHidden = true
            trackGamePlayButton.isHidden = false
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(game!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    /*
    @IBAction func trackGamePlayButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "TrackPlaySegue", sender: game)
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrackPlaySegue" {
            
            let nextVC = segue.destination as! PlayRecordViewController
            nextVC.game = game
        }

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
