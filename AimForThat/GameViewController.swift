//
//  ViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 30/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import QuartzCore
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetNumberLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var particleView: UIView!
    
    var targetValue = 0
    var score       = 0
    var round       = 0
    var time        = 0
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        time = 60
        
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
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        view.layer.add(transition, forKey: nil)
        
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        randomNumber()
        slider.value = 50
        round += 1
        roundLabel.text = "\(round)"
        scoreLabel.text = "\(score)"
        timeLabel.text  = "\(time)"
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
            title = "BOOOOM! Perfect Score!"
            points = (10 * points)
            particleEmiter()
            tapticFeedback()
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
        
        let alert = UIAlertController(title: title, message: "You scored \(points) points", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in
            self.startNewRound()
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        })
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        score = 0
        round = 0
        time  = 60
        startNewRound()
    }
    
    @objc func tick() {
        time -= 1
        timeLabel.text = "\(time)"
        if time <= 0 {
            self.timer?.invalidate()
            let alert = UIAlertController(title: "Game over!", message: "You scored \(score) points in \(round) rounds!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: {action in
                self.score = 0
                self.round = 0
                self.time  = 60
                self.startNewRound()
            })
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func tapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func particleEmiter() {
        let sk: SKView = SKView()
        sk.frame = particleView.bounds
        sk.backgroundColor = .clear
        particleView.addSubview(sk)
        sk.tag = 100
        
        let scene: SKScene = SKScene(size: particleView.bounds.size)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        
        let rightParticle = SKEmitterNode(fileNamed: "MyParticle.sks")
        rightParticle?.position = .init(x: UIScreen.main.bounds.width + 20, y: (UIScreen.main.bounds.height)/2)
        
        let leftParticle = SKEmitterNode(fileNamed: "MyParticle.sks")
        leftParticle?.position = .init(x: -20, y: (UIScreen.main.bounds.height)/2)
        leftParticle?.emissionAngle = 20
        leftParticle?.emissionAngle = 0.34
        
        scene.addChild(rightParticle!)
        scene.addChild(leftParticle!)
        sk.presentScene(scene)
    }
}

