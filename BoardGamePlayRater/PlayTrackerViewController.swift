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
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    var game : Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        if game != nil {
            // gameImageView.image = UIImage(data: game!.image! as! Data)
            gameLabel.text = game!.name
            gameLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            //gameLabel.layer.borderColor = UIColor.black.cgColor
            //gameLabel.layer.borderWidth = 1.0
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
