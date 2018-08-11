//
//  GameScene.swift
//  IdleAnimals
//
//  Created by Tom Warhurst on 30/07/2018.
//  Copyright © 2018 TommyCakes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneD: SKScene {
    
    var cowButton = SKSpriteNode()
    var pigButton = SKSpriteNode()
    var goatButton = SKSpriteNode()
    var milkUprgadeButton = SKSpriteNode()
    var moneyText = SKLabelNode()
    var cowClickPowerCostText = SKLabelNode()
    
    var autoClickCoolDown : Double = 60.0
    var moneyInBank : Int = 0
    var moneyEarntPerClick : Int = 1
    var animalClickCount : Int = 0
    var animalClickThreshold = [Int]()
    var animalThresholdIndex = 0
    var idleClick : Int = 1
    var autoClickCoolDownAmount = 60.0
    
    var cowClickPower : Int = 1
    var cowClickPowerCost = 1
    var pigClickPower : Int = 1
    var goatClickPower : Int = 1
    
    override func didMove(to view: SKView) {
        cowButton = self.childNode(withName: "cow") as! SKSpriteNode
        pigButton = self.childNode(withName: "pig") as! SKSpriteNode
        goatButton = self.childNode(withName: "goat") as! SKSpriteNode
        milkUprgadeButton = self.childNode(withName: "increaseMilkProduction") as! SKSpriteNode
        moneyText = self.childNode(withName: "moneyText") as! SKLabelNode
        cowClickPowerCostText = self.childNode(withName: "cowClickPowerCostText") as! SKLabelNode
        
        //        animalClickThreshold = [100, 150, 200, 250]
        // work on better values
        animalClickThreshold = [20, 40, 60, 80, 100, 150, 200, 400, 800, 1200, 3000]
    }
    
    func increaseMoney() {
        moneyInBank += moneyEarntPerClick
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            var t = animalClickThreshold[animalThresholdIndex]
            if (animalClickCount >= Int(t)) {
                moneyEarntPerClick += 5
                idleClick += 1
                animalThresholdIndex += 1
                autoClickCoolDownAmount -= 1.2
            }
            
            if cowButton.contains(location) {
                moneyInBank += cowClickPower
            } else if pigButton.contains(location) {
                moneyInBank += pigClickPower
            } else if goatButton.contains(location) {
                moneyInBank += goatClickPower
            } else if milkUprgadeButton.contains(location) {
                if moneyInBank - cowClickPowerCost >= 0 {
                    upgradeClickPowerOnAnimal(animal: "cow")
                }
            }
            
            animalClickCount += 1
            print("Money per click:\(moneyEarntPerClick)")
            print("Animal click count:\(animalClickCount)")
        }
    }
    
    func autoClick() {
        moneyInBank += idleClick
    }
    
    func upgradeClickPowerOnAnimal(animal : String) {
        switch animal {
        case "cow":
            cowClickPower += 1
            moneyInBank -= cowClickPowerCost
            cowClickPowerCost += 2
            break
        case "pig":
            pigClickPower += 1
            break
        case "goat":
            goatClickPower += 1
            break
        default:
            break
        }
        
    }
    
    func updateUI() {
        moneyText.text = "£\(moneyInBank)"
        cowClickPowerCostText.text = "Milk +: £\(cowClickPowerCost)"
    }
    
    override func update(_ dt: TimeInterval) {
        // Called before each frame is rendered
        updateUI()
        
        //        print(autoClickCoolDown)
        autoClickCoolDown -= 0.2
        if (autoClickCoolDown <= 0) {
            autoClick()
            autoClickCoolDown = autoClickCoolDownAmount
        }
    }
}
