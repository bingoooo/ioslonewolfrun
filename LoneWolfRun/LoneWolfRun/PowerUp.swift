//
//  PowerUp.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 03/09/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUp: SKSpriteNode{
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let texture = SKTexture(imageNamed: "star")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
        physicsBody!.collisionBitMask = 0
        name = "POWER_UP_ORB"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}