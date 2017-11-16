//
//  ViewController.swift
//  DiceGame
//
//  Created by wilson on 2017/11/14.
//  Copyright © 2017年 wilson. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    var showCurrentMoney = 500
    var isBig = false
    var isSmall = false

    //reset dice
    func resetDice(){
        self.diceA.frame.origin.y = gameUIResult.frame.origin.y
        self.diceA.alpha = 0
        self.diceA.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    //dice animation
    func diceAnimation(){
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, animations:{
//            let diceABC = ["diveA","diveB","diveC"]
//            let randomDistribution = GKShuffledDistribution(lowestValue: 0, highestValue:diceABC.count-1)
//            let number = randomDistribution.nextInt()
            //For Peter 想要把邊slef.diceA ->改成 self.diceABC[number]
            self.diceA.frame.origin.y = self.gameUIResult.frame.height / 2.5
            self.diceA.alpha = 1
            self.diceA.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        })
        
    }
    
    @IBOutlet weak var gameResultBtn: UIButton!
    //dice 產生亂數與回報金額
    func radomDice() -> Int {
        let randomDistribution = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        let numberA = randomDistribution.nextInt()
        let numberB = randomDistribution.nextInt()
        let numberC = randomDistribution.nextInt()
        var totalNumber:Int
        totalNumber = numberA + numberB + numberC
        
        if totalNumber >= 9  {
            gameUIResult.image = UIImage(named:"img03")
            if isBig == true{
                showCurrentMoney += 100
            } else if isBig == false{
                showCurrentMoney -= 100
            }
        return showCurrentMoney
        } else {
            gameUIResult.image = UIImage(named:"img02")
            if isSmall == true{
                showCurrentMoney += 100
            } else if isSmall == false{
                showCurrentMoney -= 100
            }
        
        }
        return showCurrentMoney
    }

    @IBOutlet weak var currentMoney: UILabel!
    @IBOutlet weak var diceC: UIImageView!
    @IBOutlet weak var diceB: UIImageView!
    @IBOutlet weak var diceA: UIImageView!
    @IBOutlet weak var gameUIResult: UIImageView!
    
    
    @IBAction func smallBtn(_ sender: Any) {
        self.gameResultBtn.alpha = 1
        gameUIResult.image = UIImage(named:"img01")
        isSmall = true
        isBig = false
        resetDice()
    }
    
    @IBAction func bigBtn(_ sender: Any) {
        self.gameResultBtn.alpha = 1
        gameUIResult.image = UIImage(named:"img01")
        isSmall = false
        isBig = true
        resetDice()
    }
    
    @IBAction func gameResult(_ sender: Any) {

        diceAnimation()
        gameResultBtn.alpha = 0
        
        let when = DispatchTime.now() + 0.65 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.radomDice()
            self.currentMoney.text = "\(self.showCurrentMoney)"
        }

        if showCurrentMoney == 0 {
            print("game over")
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
