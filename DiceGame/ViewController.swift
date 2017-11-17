//
//  ViewController.swift
//  DiceGame
//
//  Created by wilson on 2017/11/14.
//  Copyright © 2017年 wilson. All rights reserved.
//

import UIKit
import GameplayKit
import AVFoundation

class ViewController: UIViewController {

    var showCurrentMoney = 500
    var isBig = false
    var isSmall = false
    var totalNumber:Int = 0
    var player: AVAudioPlayer?
    
    func playSound(soundName:String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //reset dice
    func resetDice(){

        self.diceA.frame.origin.y = gameUIResult.frame.origin.y
        self.diceA.alpha = 0
        self.diceA.transform = CGAffineTransform(rotationAngle: 0)
        self.diceB.frame.origin.y = gameUIResult.frame.origin.y
        self.diceB.alpha = 0
        self.diceB.transform = CGAffineTransform(rotationAngle: 0)
        self.diceC.frame.origin.y = gameUIResult.frame.origin.y
        self.diceC.alpha = 0
        self.diceC.transform = CGAffineTransform(rotationAngle: 0)

    }
    
    //dice animation
    func diceAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, animations:{
            self.diceA.frame.origin.y = self.gameUIResult.frame.height / 2.5
            self.diceB.frame.origin.y = self.gameUIResult.frame.height / 2.6
            self.diceC.frame.origin.y = self.gameUIResult.frame.height / 2.6
            self.diceA.alpha = 1
            self.diceB.alpha = 1
            self.diceC.alpha = 1
            self.diceA.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.diceB.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.diceC.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        })
    }
    
    @IBOutlet weak var gameResultBtn: UIButton!
    //dice 產生亂數與回報金額
    func radomDice() -> Int {
        let randomDistribution = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        let numberA = randomDistribution.nextInt()
        let numberB = randomDistribution.nextInt()
        let numberC = randomDistribution.nextInt()
        let imageNameA = "dicePoint\(numberA)"
        let imageNameB = "dicePoint\(numberB)"
        let imageNameC = "dicePoint\(numberC)"
        
        totalNumber = numberA + numberB + numberC
        diceA.image = UIImage(named:imageNameA)
        diceB.image = UIImage(named:imageNameB)
        diceC.image = UIImage(named:imageNameC)
        
        return totalNumber
    }

    @IBOutlet weak var smallBtnUI: UIImageView!
    @IBOutlet weak var bigBtnUI: UIImageView!
    @IBOutlet weak var currentMoney: UILabel!
    @IBOutlet weak var diceC: UIImageView!
    @IBOutlet weak var diceB: UIImageView!
    @IBOutlet weak var diceA: UIImageView!
    @IBOutlet weak var gameUIResult: UIImageView!
    @IBOutlet weak var okayGo: UIImageView!
    
    
    @IBAction func smallBtn(_ sender: Any) {
        self.bigBtnUI.alpha = 0.1
        self.smallBtnUI.alpha = 1
        self.radomDice()
        self.okayGo.alpha = 1
        gameUIResult.image = UIImage(named:"img01")
        smallBtnUI.image = UIImage(named:"smallBtnRed")
        bigBtnUI.image = UIImage(named:"bigBtn")
        isSmall = true
        isBig = false
        resetDice()
    }
    
    @IBAction func bigBtn(_ sender: Any) {
        self.smallBtnUI.alpha = 0.1
        self.bigBtnUI.alpha = 1
        self.radomDice()
        self.okayGo.alpha = 1
        gameUIResult.image = UIImage(named:"img01")
        bigBtnUI.image = UIImage(named:"bigBtnRed")
        smallBtnUI.image = UIImage(named:"smallBtn")
        isSmall = false
        isBig = true
        resetDice()
        
    }
    
    @IBAction func gameResult(_ sender: Any) {
        smallBtnUI.alpha = 1
        bigBtnUI.alpha = 1
        okayGo.alpha = 0.1
        diceAnimation()
        
        let when = DispatchTime.now() + 0.65 // change 2 to desired number of seconds
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.currentMoney.text = "\(self.showCurrentMoney)"
            self.smallBtnUI.image = UIImage(named:"smallBtn")
            self.bigBtnUI.image = UIImage(named:"bigBtn")
        }

        if showCurrentMoney == 0 {
            print("game over")
        }
        
        if totalNumber >= 9  {
            gameUIResult.image = UIImage(named:"img03")
            if isBig == true{
                showCurrentMoney += 100
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.gameUIResult.image = UIImage(named:"img04")
                    self.playSound(soundName: "Win")
                }
            } else if isBig == false{
                showCurrentMoney -= 100
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.gameUIResult.image = UIImage(named:"img05")
                    self.playSound(soundName: "Lose")
                }
            }
        } else {
            gameUIResult.image = UIImage(named:"img02")
            if isSmall == true{
                showCurrentMoney += 100
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.gameUIResult.image = UIImage(named:"img06")
                    self.playSound(soundName: "Win")
                }
            } else if isSmall == false{
                showCurrentMoney -= 100
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.gameUIResult.image = UIImage(named:"img07")
                    self.playSound(soundName: "Lose")
                }
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
