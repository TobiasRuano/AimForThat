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
    @IBOutlet weak var maxNumberLabel: UILabel!
    
    var targetValue     = 0
    var score           = 0
    var round           = 0
    var time            = 0
    var timer  : Timer?
    var difficulty      = 0
    var maxRandomNumber = 0
    struct SavedScore: Codable {
        var easy = 0
        var medium = 0
        var hard = 0
    }
    
    var bestScore = SavedScore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDifficulty()
        setBestScore()
        setupSlider()
        time = 60
        startNewRound()
        
        print(bestScore)
    }
    
    func setDifficulty() {
        switch difficulty {
        case 0:
            setUI(maxNumber: 10)
        case 1:
            setUI(maxNumber: 100)
        case 2:
            setUI(maxNumber: 1000)
        default:
            print("difficulty not found")
        }
    }
    
    //TODO: Does not work
    func setBestScore () {
        
//        if let data = UserDefaults.standard.value(forKey: "bestscore") as? Data {
//            bestScore = try! PropertyListDecoder().decode(SavedScore.self, from: data)
//        } else {
//            bestScore.easy = 0
//            bestScore.medium = 0
//            bestScore.hard = 0
//        }
        
        if let savedScore = UserDefaults.standard.object(forKey: "bestScore") as? Data {
            let decoder = JSONDecoder()
            if let loadedScore = try? decoder.decode(SavedScore.self, from: savedScore) {
                bestScore = loadedScore
            } else {
                bestScore.easy = 0
                bestScore.medium = 0
                bestScore.hard = 0
            }
        }
    }
    
    func setUI(maxNumber: Int) {
        maxRandomNumber = maxNumber
        slider.maximumValue = Float(maxNumber)
        maxNumberLabel.text = "\(maxNumber)"
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
        timeLabel.textColor = .black
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
        slider.value = Float(maxRandomNumber/2)
        round += 1
        roundLabel.text = "\(round)"
        scoreLabel.text = "\(score)"
        timeLabel.text  = "\(time)"
    }
    
    func randomNumber() {
        targetValue = 1 + Int(arc4random_uniform(UInt32(maxRandomNumber)))
        targetNumberLabel.text = "\(targetValue)"
    }

    @IBAction func showAlert(_ sender: UIButton) {
        let difference = abs(lroundf(slider.value) - targetValue)
        
        var points = 0
        var title = ""
        var result : (String, Int) = ("", 0)
        
        switch maxRandomNumber {
        case 10:
            points = (maxRandomNumber * 10) - difference
            print("numero maximo: \(maxRandomNumber), diferencia: \(difference)")
        case 100:
            points = maxRandomNumber - difference
            print("numero maximo: \(maxRandomNumber), diferencia: \(difference)")
        case 1000:
            points = (maxRandomNumber - difference) / 10
            print("numero maximo: \(maxRandomNumber), diferencia: \(difference)")
        default:
            print("")
        }
        
        if difficulty == 0 {
            result = obtainScore(value: difference, points: points, maxRange1: 1, minRange2: 2, maxRange2: 2)
        }else if (difficulty == 1) {
            result = obtainScore(value: difference, points: points, maxRange1: 5, minRange2: 6, maxRange2: 12)
        }else if difficulty == 2 {
            result = obtainScore(value: difference, points: points, maxRange1: 50, minRange2: 51, maxRange2: 170)
        }
        
        title = result.0
        points = result.1
        
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
    
    func obtainScore (value: Int, points: Int, maxRange1: Int, minRange2: Int, maxRange2: Int) -> (String, Int) {
        var title = ""
        var newPoints = 0
        
        switch value {
        case 0:
            title = "BOOOOM! Perfect Score!"
            newPoints = (10 * points)
            particleEmiter()
            tapticFeedback()
        case 1...maxRange1:
            title = "Almost!!"
            newPoints = Int(Double(points) * 1.5)
        case minRange2...maxRange2:
            title = "A litle bit more!"
            newPoints = Int(Double(points) * 1.2)
        default:
            title = "Try again"
            newPoints = points
        }
        
        return (title, newPoints)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
//        score = 0
//        round = 0
//        time  = 60
//        startNewRound()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tick() {
        time -= 1
        if time <= 5 {
            timeLabel.textColor = .red
        }else {
            timeLabel.textColor = .black
        }
        if time <= 0 {
            timeLabel.text = "0"
            self.timer?.invalidate()
            
            saveBestScore(score: score)
            
            let alert = UIAlertController(title: "Game over!", message: "You scored \(score) points in \(round) rounds!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: {action in
                self.score = 0
                self.round = 0
                self.time  = 60
                
                self.startNewRound()
            })
            alert.addAction(action)
            present(alert, animated: true)
        }else {
            timeLabel.text = "\(time)"
        }
    }
    
    func saveBestScore(score: Int) {
        if difficulty == 0 {
            if score > bestScore.easy {
                bestScore.easy = score
            }
        } else if difficulty == 1 {
            if score > bestScore.medium {
                bestScore.medium = score
            }
        } else if difficulty == 2 {
            if score > bestScore.hard {
                bestScore.hard = score
            }
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bestScore) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "bestScore")
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
        
        let rightParticle = SKEmitterNode(fileNamed: "bulls-eye.sks")
        rightParticle?.position = .init(x: UIScreen.main.bounds.width + 20, y: (UIScreen.main.bounds.height)/2)
        
        let leftParticle = SKEmitterNode(fileNamed: "bulls-eye.sks")
        leftParticle?.position = .init(x: -20, y: (UIScreen.main.bounds.height)/2)
        leftParticle?.emissionAngle = 20
        leftParticle?.emissionAngle = 0.34
        
        scene.addChild(rightParticle!)
        scene.addChild(leftParticle!)
        sk.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

