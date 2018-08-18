//
//  GameScene.swift
//  IdleAnimals
//
//  Created by Tom Warhurst on 30/07/2018.
//  Copyright © 2018 TommyCakes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, MonsterDelegate {
    
    var updateInterval = 0
    let UPDATE_TIMER = 2000
    
    var lastUpdateDate: Date? = nil
    
    var currentMonster: Monster?
    var clickDamage = 1
    var monstersKilled = 0
    var coinsInBank = 0
    var autoAttackDamage = 0
    var critChancePercentage = 1
    var critDamage = 100
    var spellAttackDamage = 0
    
    var attackUpgradeCost = 5
    var autoAttackUpgradeCost = 15
    var spellUpgradeCost = 30
    var critChanceUpgradeCost = 35
    var autoClickCoolDown = 60.0
    var autoClickCoolDownAmount = 60.0
    var coinMultiplier = 1
    var level = 1
    var levelKills = 0
    let LEVEL_KILLS_REQUIRED = 10
    
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
    
    override func didMove(to view: SKView) {
        
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
        
        createMonster()
    }
    
    func createMonster() {
        self.currentMonster = Monster(position: CGPoint(x: 100, y: 100 * 10), index: monstersKilled, isBoss: levelKills == LEVEL_KILLS_REQUIRED - 1)
        if let monster = self.currentMonster {
            monster.delegate = self
            monster.zPosition = 1001
            monster.isUserInteractionEnabled = true
            self.addChild(monster)
            let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 2)
            let sequence = SKAction.sequence([moveUp, moveUp.reversed()])
            monster.run(SKAction.repeatForever(sequence), withKey:  "moving")
            monsterNameText.text = "\(monster.monsterName)"
        }
    }
    
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
        
        generateCoin()
        
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
    
    func killMonster(monster: Monster) {
        monster.removeFromParent()
        monstersKilled += 1
        coinsInBank += 10
        spawnCoin()

        levelKills += 1
        
        if (levelKills >= LEVEL_KILLS_REQUIRED) {
            level += 1;
            levelKills = 0;
        }
        createMonster()
    }
    
    
    func rollCrit() -> Int {
        return Int(arc4random_uniform(100) + UInt32(critChancePercentage))
    }
    
    func attack(auto: Bool) {
        let critChance = rollCrit()
        print("Crit chance \(critChance)")
        var damage: Int = 0
        if auto == true {
            damage = autoAttackDamage
        } else {
            damage = critChance <= critChancePercentage ? critDamage : clickDamage
        }
        currentMonster?.health -= damage
        
        if let monsterHealth = currentMonster?.health {
            print(monsterHealth)
        }
    }
    
    func monsterClicked(_ monster: Monster) {
        attack(auto: false)
    }
    
    func monsterDied(_ monster: Monster) {
        killMonster(monster: monster)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
                        
            if attackButton.contains(location) {
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
        if let monsterHealth = currentMonster?.health {
            healthPointsText.text = "\(monsterHealth) HP"
        }
        attackText.text = "Attack: \(clickDamage)"
        autoAttackText.text = "DPS: \(autoAttackDamage)"
        critChanceText.text = "Crit: \(critChancePercentage) %"
        // add spell chance text
        attackCostText.text = "G: \(attackUpgradeCost)"
        autoAttackCostText.text = "G: \(autoAttackUpgradeCost)"
        critChanceCostText.text = "G: \(critChanceUpgradeCost)"
        spellCostText.text = "G: \(spellUpgradeCost)"
        levelText.text = "Level: \(level)"
        killCountText.text = "Kills: \(levelKills)/\(LEVEL_KILLS_REQUIRED)"
    }
    
    override func update(_ dt: TimeInterval) {
        
        let now: Date = Date()
        
        if lastUpdateDate == nil {
            lastUpdateDate = now
        }
        
        if now.timeIntervalSince(lastUpdateDate!) >= 1 {
            attack(auto: true)
            lastUpdateDate = now
        }
        
        updateUI()
    }
}
