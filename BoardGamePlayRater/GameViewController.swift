//
//  GameViewController.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 7/20/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var game : Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if game != nil {
            nameTextField.text = game!.name
        } else {
            
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
                game.name = nameTextField.text
                
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
