//
//  PlayTrackerViewController.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 7/22/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class PlayTrackerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var trackGamePlayButton: UIButton!
    @IBOutlet weak var graph: GraphView!
    
    @IBOutlet weak var ratingAxisLabel: UILabel!
    
    @IBOutlet weak var playerAxisLabel: UILabel!
    
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
        
        ratingAxisLabel.transform = CGAffineTransform( rotationAngle: CGFloat(( -90 * Double.pi ) / 180) )
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        if game != nil {
            if game!.image != nil {
                gameImageView.image = UIImage(data: game!.image! )
            }
            gameImageView.contentMode = .scaleAspectFill
            gameImageView.clipsToBounds = true
            
            self.title = game!.name
            // Add drop shadow to gameRatingLabel:
            gameRatingLabel.layer.shadowColor = UIColor.black.cgColor
            gameRatingLabel.layer.shadowRadius = 3.0
            gameRatingLabel.layer.shadowOpacity = 1.0
            gameRatingLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
            gameRatingLabel.layer.masksToBounds = false
            
            let colorValue = getRatingColor(rating: game!.rating)
            gameRatingLabel.backgroundColor = colorValue
            gameImageView.backgroundColor = colorValue.withAlphaComponent(0.5)
            // ratingColor(rating: game!.rating)
            
            
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
    
/********* GRAPH CODE HERE: ***********/
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
        graph.dataEntries = dataEntries
    }
    
    func generateDataEntries() -> [BarElement] {
        let color = UIColor(red:1.0, green:0.75, blue:0.0, alpha:1.0)
        var result: [BarElement] = []
        
        // Determine possible number of players: 
        let maxPlayerCount : Int16 = (game?.maxPlayerCount)!
        let minPlayerCount : Int16 = (game?.minPlayerCount)!
        var barCount = Int(maxPlayerCount) - Int(minPlayerCount) + 1
        var limitToTen = false
        if barCount > 10 {
            limitToTen = true
            barCount = 10
        }
        
        // For each possible # of players for the current game, add a bar
        for i in 0..<barCount {
            
            let value = 10 // ******************* REPLACE WITH VALUE FROM EACH PLAYER CATEGORY
            
            
            let height: Float = Float(value) / 10.0
            let currentBarPlayerCount = Int(minPlayerCount) + i
            if (i == barCount - 1) && (limitToTen) {
                result.append(BarElement(color: color, height: height, textValue: "\(value)", title: "\(currentBarPlayerCount)+"))
            } else {
               result.append(BarElement(color: color, height: height, textValue: "\(value)", title: "\(currentBarPlayerCount)"))
            }
            
        }
        return result
    }

/******** OTHER GUI CODE HERE: ************/
    func getRatingColor(rating : Double) -> UIColor {
        var color : UIColor
        if  rating >= 0.0 && rating < 1.0 {
            color = UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        } else if rating >= 1.0 && rating < 2.0 {
            color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        } else if rating >= 2.0 && rating < 3.0 {
            color = UIColor(red: 1, green: 51/255, blue: 153/255, alpha: 1)
        } else if rating >= 3.0 && rating < 4.0 {
            color = UIColor(red: 1, green: 153/255, blue: 1, alpha: 1)
        } else if rating >= 4.0 && rating < 5.0 {
            color = UIColor(red: 153/255, green: 153/255, blue: 1, alpha: 1)
        } else if rating >= 5.0 && rating < 6.0 {
            color = UIColor(red: 204/255, green: 153/255, blue: 1, alpha: 1)
        } else if rating >= 6.0 && rating < 7.0 {
            color = UIColor(red: 153/255, green: 1, blue: 1, alpha: 1)
        } else if rating >= 7.0 && rating < 8.0 {
            color = UIColor(red: 153/255, green: 1, blue: 153/255, alpha: 1)
        } else if rating >= 8.0 && rating < 9.0 {
            color = UIColor(red: 102/255, green: 204/255, blue: 102, alpha: 1)
        } else if rating >= 9.0 && rating < 10.0 {
            color = UIColor(red: 0, green: 204, blue: 0, alpha: 1)
        } else if rating == 10.0 {
            color = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        } else {
            color = UIColor.lightGray
        }
        return color
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            // user just tapped the Edit button (it now says Done)
            deleteButton.isHidden = false
            trackGamePlayButton.isHidden = true
            ratingAxisLabel.isHidden = true
            playerAxisLabel.isHidden = true
            graph.isHidden = true
        } else {
            // user just tapped the Done button (it now says Edit)
            deleteButton.isHidden = true
            trackGamePlayButton.isHidden = false
            ratingAxisLabel.isHidden = false
            playerAxisLabel.isHidden = false
            graph.isHidden = false
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(game!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
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
