//
//  GameListViewController.swift
//  BoardGamePlayRater
//
//  Created by Maria Beutel on 7/20/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class GameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var games : [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            games = try context.fetch(Game.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameProtoCell") as! GameTableViewCell
        
        cell.gameNameLabel.text = game.name
        cell.gameRatingLabel.backgroundColor = getRatingColor(rating: game.rating)
        if (game.rating == 11.0) {
            cell.gameRatingLabel.text = "N/A"
        } else {
            cell.gameRatingLabel.text = "\(game.rating)"
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        self.performSegue(withIdentifier: "PresentPlayTrackerSegue", sender: game)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentPlayTrackerSegue" {
            let nextVC = segue.destination as! PlayTrackerViewController
            nextVC.game = sender as? Game
        }
    }
    
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

}

