////
////  Monster.swift
////  IdleAnimals
////
////  Created by Tom Warhurst on 31/07/2018.
////  Copyright © 2018 TommyCakes. All rights reserved.

import Foundation
import SpriteKit

protocol MonsterDelegate {
    func monsterClicked(_ monster: Monster)
    func monsterDied(_ monster: Monster)
}

class Monster: SKSpriteNode {
    
    static var monsterImageData = [
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
    
    static var monsterNameData = [
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
    
    static var monsterHPProgression = [10, 15, 25, 30, 35, 50, 68, 80, 100, 110, 115, 125, 130, 135, 150, 168, 180, 200, 210, 215, 225, 230, 235, 250, 268, 280, 300]
    
    var delegate: MonsterDelegate?
    var MAX_HEALTH: Int
    let BOSS_HEALTH_MULTIPLIER = 3
    var health: Int {
        didSet {
            if health <= 0 {
                delegate?.monsterDied(self)
            }
        }
    }
    var monsterName: String

    init(position: CGPoint, color: UIColor? = nil, index: Int, isBoss: Bool = false) {
        let texture = SKTexture(imageNamed: Monster.monsterImageData[index % Monster.monsterImageData.count])
        let size = CGSize(width: texture.size().width, height: texture.size().height)
        self.health = Monster.monsterHPProgression[index % Monster.monsterHPProgression.count]
        if isBoss {
            self.health *= BOSS_HEALTH_MULTIPLIER
        }
        self.MAX_HEALTH = self.health
        monsterName = Monster.monsterNameData[index % Monster.monsterNameData.count]
        super.init(texture: texture, color: color ?? .clear, size: size)
        self.name = "monster"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateMonsterDamage() {
        let randomAngleRadians = CGFloat(Float(arc4random()) / Float(UINT32_MAX) * Float.pi)
        let moveRandom = SKAction.moveBy(x: -10*cos(randomAngleRadians), y: 10*sin(randomAngleRadians), duration: 0.05)
        run(SKAction.sequence([moveRandom, moveRandom.reversed()]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.monsterClicked(self)
    }
}

