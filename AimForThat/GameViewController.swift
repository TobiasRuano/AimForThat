//
//  ViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 30/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetNumberLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var targetValue = 0
    var score = 0
    var round = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        
        startNewRound()
    }
    
    func setupSlider() {
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackRightImage = UIImage(named: "SliderTrackRight")
        
        slider.setThumbImage(thumbImageNormal, for: .normal)
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = trackLeftImage?.resizableImage(withCapInsets: insets)
        let trackRightResizable = trackRightImage?.resizableImage(withCapInsets: insets)
        
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    
    func startNewRound() {
        randomNumber()
        slider.value = 50
        round += 1
        roundLabel.text = "\(round)"
        scoreLabel.text = "\(score)"
    }
    
    func randomNumber() {
        targetValue = 1 + Int(arc4random_uniform(100))
        targetNumberLabel.text = "\(targetValue)"
    }

    @IBAction func showAlert(_ sender: UIButton) {
        let difference = abs(lroundf(slider.value) - targetValue)
        
        var points = 100 - difference
        
        var title = ""
        
        switch difference {
        case 0:
            title = "BOOOOM! Perfect Score"
            points = (10 * points)
        case 1...5:
            title = "Almost!!"
            points = Int(Double(points) * 1.5)
        case 6...12:
            title = "A litle bit more!"
            points = Int(Double(points) * 1.2)
        default:
            title = "Try again"
        }
        self.score += points
        
        let alert = UIAlertController(title: title, message: "\(points)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in
            self.startNewRound()
        })
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        score = 0
        round = 0
        startNewRound()
    }
    
}

