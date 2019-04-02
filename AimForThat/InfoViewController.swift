//
//  InfoViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 30/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
