//
//  MainMenuViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 31/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoXConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func animateLogo() {
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { () -> Void in
                self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
            
            self.logoXConstraint.constant = -50
            self.logoHeight.constant = 150
            self.logoWidth.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateLogo()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
