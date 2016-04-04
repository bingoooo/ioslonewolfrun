//
//  MenuScene.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 02/09/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import Foundation
import SpriteKit


class MenuScene: SKScene{
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(size: CGSize, gameResult: Bool, score: Int){
        super.init(size: size)
        
        
        
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: 160.0, y: 0.0)
        addChild(backgroundNode)
        
        let gameResultTextNode = SKLabelNode(fontNamed: "Copperplate")
        gameResultTextNode.text = "YOU " + (gameResult ? "WON" : "LOST")
        gameResultTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        gameResultTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        gameResultTextNode.fontSize = 20
        gameResultTextNode.fontColor = SKColor.grayColor()
        gameResultTextNode.position = CGPointMake(size.width / 2, size.height - 200)
        addChild(gameResultTextNode)
        
        let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreTextNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.grayColor()
        scoreTextNode.position = CGPointMake(size.width / 2, gameResultTextNode.position.y - 40)
        addChild(scoreTextNode)
        
        let tryAgainTextNodeLine1 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainTextNodeLine1.text = "TAP ANYWHERE"
        tryAgainTextNodeLine1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tryAgainTextNodeLine1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tryAgainTextNodeLine1.fontSize = 20
        tryAgainTextNodeLine1.fontColor = SKColor.grayColor()
        tryAgainTextNodeLine1.position = CGPointMake(size.width / 2, 100)
        addChild(tryAgainTextNodeLine1)
        
        let tryAgainTextNodeLine2 = SKLabelNode(fontNamed: "Copperplate")
        tryAgainTextNodeLine2.text = "TO PLAY AGAIN !!"
        tryAgainTextNodeLine2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tryAgainTextNodeLine2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tryAgainTextNodeLine2.fontSize = 20
        tryAgainTextNodeLine2.fontColor = SKColor.grayColor()
        tryAgainTextNodeLine2.position = CGPointMake(size.width / 2, tryAgainTextNodeLine1.position.y - 40)
        addChild(tryAgainTextNodeLine2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let transition = SKTransition.doorsOpenHorizontalWithDuration(2.0)
        let gameScene = GameScene(size: size)
        view?.presentScene(gameScene, transition: transition)
    }
}