//
//  Coin.swift
//  IdleAnimals
//
//  Created by Tom Warhurst on 05/08/2018.
//  Copyright © 2018 TommyCakes. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    init(size: CGSize, position: CGPoint, color: UIColor? = nil, name: String? = nil) {
    let texture = SKTexture(imageNamed: "I_GoldCoin")
    super.init(texture: texture, color: color ?? .clear, size: size)
    self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
