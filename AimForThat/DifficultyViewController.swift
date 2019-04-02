//
//  DifficultyViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 31/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var difficulty = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func easyButtonPressed(_ sender: UIButton) {
        difficulty = 0
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    @IBAction func mediumButtonPressed(_ sender: UIButton) {
        difficulty = 1
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    @IBAction func hardButtonPressed(_ sender: UIButton) {
        difficulty = 2
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
     //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let vc = segue.destination as! GameViewController
            vc.difficulty = difficulty
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
