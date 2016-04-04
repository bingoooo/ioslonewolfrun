//
//  BlackHole.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 03/09/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import Foundation
import SpriteKit

class BlackHole: SKSpriteNode{
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let textureAtlas = SKTextureAtlas(named: "animation.atlas")
        
        let frame1 = textureAtlas.textureNamed("blackhole01")
        let frame2 = textureAtlas.textureNamed("blackhole02")
        let frame3 = textureAtlas.textureNamed("blackhole03")
        let frame4 = textureAtlas.textureNamed("blackhole04")
        
        let blackHoleTextures = [frame1, frame2, frame3, frame4]
        let animateAction = SKAction.animateWithTextures(blackHoleTextures, timePerFrame: 0.2)
        let rotateAction = SKAction.repeatActionForever(animateAction)
        
        super.init(texture: frame1, color: UIColor.clearColor(), size: frame1.size())
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionCategoryBlackHole
        physicsBody!.collisionBitMask = 0
        name = "BLACK_HOLE"
        
        runAction(rotateAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}