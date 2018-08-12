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
}

class Monster: SKSpriteNode {
    
    var delegate: MonsterDelegate?

    init(texture: SKTexture? = nil, size: CGSize, position: CGPoint, color: UIColor? = nil, name: String? = nil) {
        super.init(texture: texture, color: color ?? .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.monsterClicked(self)
    }
}

