//
//  GameViewController.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 20/08/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    var scene: GameScene!                       //declare scene of type GameScene
    //var backgroundNode : SKSpriteNode?
    //var playerNode : SKSpriteNode?

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true
        
        // 2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size) //instanciate scene with class GameScene
        scene.scaleMode = .AspectFill               //SKSceneScaleMode type
        
        // 3. Show the scene
        skView.presentScene(scene)
    }
    
}
