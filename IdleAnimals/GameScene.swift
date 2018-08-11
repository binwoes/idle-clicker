//
//  GameScene.swift
//  IdleAnimals
//
//  Created by Tom Warhurst on 30/07/2018.
//  Copyright © 2018 TommyCakes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var updateInterval = 0
    let UPDATE_TIMER = 2000
    
    var lastUpdateDate: Date? = nil
    
    var monsterNameData = [String]()
    var monsterImageData = [String]()
    var monsterHealth = 10
    var clickDamage = 1
    var monsterIndex = 0
    var coinsInBank = 0
    var autoAttackDamage = 1
    var critChancePercentage = 1
    var critDamage = 100
    var spellAttackDamage = 0
    
    //    var monsterHPProgression = [10, 25, 50, 80, 120, 180, 300, 500]
    var monsterHPProgression = [10, 15, 25, 30, 35, 50, 68, 80, 100, 110, 115, 125, 130, 135, 150, 168, 180, 200, 210, 215, 225, 230, 235, 250, 268, 280, 300]
    var attackUpgradeCost = 5
    var autoAttackUpgradeCost = 15
    var spellUpgradeCost = 30
    var critChanceUpgradeCost = 35
    var autoClickCoolDown = 60.0
    var autoClickCoolDownAmount = 60.0
    var coinMultiplier = 1
    var level = 1
    var levelKills = 0
    var levelKillsRequired = 10
    
    var attackButton = SKSpriteNode()
    var autoAttackButton = SKSpriteNode()
    var spellButton = SKSpriteNode()
    var critButton = SKSpriteNode()
    
    var monsterName = SKLabelNode()
    var coinText = SKLabelNode()
    var clickDamageText = SKLabelNode()
    var monsterNameText = SKLabelNode()
    var healthPointsText = SKLabelNode()
    var attackText = SKLabelNode()
    var autoAttackText = SKLabelNode()
    var critChanceText = SKLabelNode()
    var attackCostText = SKLabelNode()
    var autoAttackCostText = SKLabelNode()
    var spellCostText = SKLabelNode()
    var critChanceCostText = SKLabelNode()
    var levelText = SKLabelNode()
    var killCountText = SKLabelNode()
    
    
    func setup() {
        monsterImageData = [
            "aerocephal",
            "arcana_drake",
            "aurum-drakueli",
            "bat",
            "daemarbora",
            "deceleon",
            "demonic_essence",
            "dune_crawler",
            "green_slime",
            "nagaruda",
            "rat",
            "scorpion",
            "skeleton",
            "snake",
            "spider",
            "stygian_lizard"
        ]
        
        monsterNameData = [
            "Aerocephal",
            "Arcana Drake",
            "Aurum Drakueli",
            "Bat",
            "Daemarbora",
            "Deceleon",
            "Demonic Essence",
            "Dune Crawler",
            "Green Slime",
            "Nagaruda",
            "Rat",
            "Scorpion",
            "Skeleton",
            "Snake",
            "Spider",
            "Stygian Lizard",
        ]
    }
    
    override func didMove(to view: SKView) {
        
        setup()
        
        coinText = self.childNode(withName: "coinText") as! SKLabelNode
        coinText.fontColor?.setStroke()
        monsterNameText = self.childNode(withName: "monsterNameText") as! SKLabelNode
        healthPointsText = self.childNode(withName: "hpText") as! SKLabelNode
        attackText = self.childNode(withName: "attackText") as! SKLabelNode
        attackCostText = self.childNode(withName: "attackCostText") as! SKLabelNode
        autoAttackText = self.childNode(withName: "autoAttackText") as! SKLabelNode
        autoAttackCostText = self.childNode(withName: "autoAttackCostText") as! SKLabelNode
        autoAttackCostText = self.childNode(withName: "autoAttackCostText") as! SKLabelNode
        levelText = self.childNode(withName: "currentLevelText") as! SKLabelNode
        killCountText = self.childNode(withName: "killCountText") as! SKLabelNode
        spellCostText = self.childNode(withName: "spellCostText") as! SKLabelNode
        critChanceCostText = self.childNode(withName: "critChanceCostText") as! SKLabelNode
        critChanceText = self.childNode(withName: "critChanceText") as! SKLabelNode
        
        attackButton = self.childNode(withName: "attackButton") as! SKSpriteNode
        autoAttackButton = self.childNode(withName: "autoAttackButton") as! SKSpriteNode
        spellButton = self.childNode(withName: "spellButton") as! SKSpriteNode
        critButton = self.childNode(withName: "critButton") as! SKSpriteNode
        
//        drawMonster(name: monsterImageData[monsterIndex])
    }
    
    func drawMonster() {
        let texture = SKTexture(imageNamed: "spider")
        var monster = Monster(texture: texture, size: CGSize(width: texture.size().width, height: texture.size().height), position: CGPoint(x: 100, y: 100 * 10), name: "spider")
        monster.zPosition = 1001
        self.addChild(monster)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 2)
        let sequence = SKAction.sequence([moveUp, moveUp.reversed()])
        monster.run(SKAction.repeatForever(sequence), withKey:  "moving")
        monsterNameText.text = "\(monsterNameData[monsterIndex])"
        
//        let monster = Monster(, texture: String(monsterImageData[0]),  name: String(monsterNameData[0]))
    }
    
//    func nextMonster() {
//
//        if monsterIndex >= monsterNameData.count - 1{
//            monsterIndex = 0
//        }
//        drawMonster(name: monsterImageData[monsterIndex])
//        monsterHealth += monsterHPProgression[monsterIndex]
//    }
    
    func generateCoin() {
        let coinSize = CGSize(width: 100.0, height: 100.0)
        let coin = Coin(size: coinSize, position: CGPoint(x: 100, y: 100 * 10))
        coin.zPosition = 1000
        self.addChild(coin)
        coin.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
                ])
        )
    }
    
    func spawnCoin() {
        
        var coin1 = generateCoin()
        
        var coinValue = Int(arc4random_uniform(25))
        coinValue *= 4
        let finalCoinValue = (coinValue * coinMultiplier)
        coinsInBank += finalCoinValue
    }
    
    func upgradeAttack() {
        if coinsInBank >= attackUpgradeCost {
            coinsInBank -= attackUpgradeCost
            clickDamage += 1
            attackUpgradeCost *= 2
        }
    }
    
    func upgradeAutoAttack() {
        if coinsInBank >= autoAttackUpgradeCost {
            coinsInBank -= autoAttackUpgradeCost
            autoAttackDamage += 1
            autoAttackUpgradeCost *= 2
            autoClickCoolDownAmount -= 2
        }
    }
    
    func upgradeCritChance() {
        if coinsInBank >= critChanceUpgradeCost {
            coinsInBank -= critChanceUpgradeCost
            critChancePercentage += 1
            critDamage += 10
            critChanceUpgradeCost *= 3
        }
    }
    
    func upgradeSpellAttack() {
        if coinsInBank >= spellUpgradeCost {
            coinsInBank -= spellUpgradeCost
            spellAttackDamage += 10
            spellUpgradeCost *= 5
        }
    }
    
    func onKill() {
        if monsterHealth < 1 || monsterHealth == 0 {
            monsterIndex += 1
            coinsInBank += 10
            spawnCoin()
//            nextMonster()

            levelKills += 1
            
            if (levelKills >= levelKillsRequired) {
                level += 1;
                levelKills = 0;
            }
        }
    }
    
    
    func rollCrit() -> Int {
        return Int(arc4random_uniform(100) + UInt32(critChancePercentage))
    }
    
    func attack() {
        let critChance = rollCrit()
        print("Crit chance \(critChance)")
        
        if critChance <= critChancePercentage {
            if (monsterHealth <= 0) {
                onKill()
            }
            monsterHealth -= critDamage
        } else {
            monsterHealth -= clickDamage
        }
        
        onKill()
        
        print(monsterHealth)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if monster.contains(location) {
                attack()
            } else if attackButton.contains(location) {
                upgradeAttack()
            } else if autoAttackButton.contains(location) {
                upgradeAutoAttack()
            } else if critButton.contains(location) {
                upgradeCritChance()
            } else if spellButton.contains(location) {
                upgradeSpellAttack()
            }
        }
    }

    func updateUI() {
        coinText.text = "Gold: \(coinsInBank)"
        healthPointsText.text = "\(monsterHealth) HP"
        attackText.text = "Attack: \(clickDamage)"
        autoAttackText.text = "DPS: \(autoAttackDamage)"
        critChanceText.text = "Crit: \(critChancePercentage) %"
        // add spell chance text
        attackCostText.text = "G: \(attackUpgradeCost)"
        autoAttackCostText.text = "G: \(autoAttackUpgradeCost)"
        critChanceCostText.text = "G: \(critChanceUpgradeCost)"
        spellCostText.text = "G: \(spellUpgradeCost)"
        levelText.text = "Level: \(level)"
        killCountText.text = "Kills: \(levelKills)/\(levelKillsRequired)"
    }
    
    func autoClick() {
        monsterHealth -= autoAttackDamage
        onKill()
        
    }
    
    override func update(_ dt: TimeInterval) {
        
        let now: Date = Date()
        
        if lastUpdateDate == nil {
            lastUpdateDate = now
        }
        
        if now.timeIntervalSince(lastUpdateDate!) >= 1 {
            autoClick()
            lastUpdateDate = now
        }
        
        updateUI()
    }
}
