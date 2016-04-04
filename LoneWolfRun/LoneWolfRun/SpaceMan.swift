//
//  SpaceMan.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 02/09/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import Foundation
import SpriteKit

class SpaceMan: SKSpriteNode{

    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
    
        let texture = SKTexture(imageNamed: "ship_32x32")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        self.physicsBody!.contactTestBitMask = CollisionCategoryBlackHole | CollisionCategoryPowerUpOrbs
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.dynamic = false
        self.physicsBody!.linearDamping = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}