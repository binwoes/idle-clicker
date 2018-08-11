////
////  Monster.swift
////  IdleAnimals
////
////  Created by Tom Warhurst on 31/07/2018.
////  Copyright © 2018 TommyCakes. All rights reserved.

import Foundation
import SpriteKit

class Monster: SKSpriteNode {
    
    public var monsterNameData = [String]()
    public var monsterImageData = [String]()
    public var monsterHealth = 10


    init(texture: SKTexture? = nil, size: CGSize, position: CGPoint, color: UIColor? = nil, name: String? = nil) {
        super.init(texture: texture, color: color ?? .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

