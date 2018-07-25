//
//  GameListViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 7/20/18.
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
        let cell = UITableViewCell()
        let game = games[indexPath.row]
        cell.textLabel?.text = game.name
        //cell.imageView?.image = UIImage(data : game.image as! Data)
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

}

