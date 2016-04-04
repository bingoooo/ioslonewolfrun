//
//  GameScene.swift
//  LoneWolfRun
//
//  Created by Benjamin Dant on 20/08/2015.
//  Copyright (c) 2015 Benjamin Dant. All rights reserved.
//

import SpriteKit
import CoreMotion   //accelerator motion inputs...

class GameScene: SKScene, SKPhysicsContactDelegate {
    //Node declarations
    var backgroundNode : SKSpriteNode?
    var foregroundNode : SKSpriteNode?
    var planetBackground : SKSpriteNode?
    var backgroundStars : SKSpriteNode?
    
    //player variables
    var playerNode : SKSpriteNode?
    
    
    //accelerator management
    var coreMotionManager = CMMotionManager()
    var xAxisAcceleration : CGFloat = 0.0
    
    //collision variables
    //let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    //let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    //let CollisionCategoryBlackHole : UInt32 = 0x1 << 3
    
    
    
    //particles declarations
    var engineExhaust : SKEmitterNode?
    var exhaustTimer : NSTimer?
    
    //displays
    //score declarations
    var score = 0
    var scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
    //inpulse count
    var impulseCount = 40
    var impulseTextNode = SKLabelNode(fontNamed: "Copperplate")
    //initial tap to start display
    let startGameNode = SKLabelNode(fontNamed: "Copperplate")
    
    //sounds
    let orbPopAction = SKAction.playSoundFileNamed("star_pop.mp3", waitForCompletion: false)
    let impulsePopAction = SKAction.playSoundFileNamed("flyby.mp3", waitForCompletion: false)
    let blackHolePopAction = SKAction.playSoundFileNamed("blackhole_contact.mp3", waitForCompletion: false)
    let music01 = SKAction.playSoundFileNamed("bgm01.mp3", waitForCompletion: false)
    var musicOn = false
    //let playList = SKAction.sequence()
        
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //add power ups method
    func addOrbsToForeground(){
        var orbNodePosition = CGPoint(x: playerNode!.position.x, y: playerNode!.position.y + 100)
        var orbXShift : CGFloat = -1.0
        
        for _ in 1...50{
            let orbNode = PowerUp()
            
            if orbNodePosition.x - (orbNode.size.width * 2) <= 0 {
                orbXShift = 1.0
            }
            
            if orbNodePosition.x + orbNode.size.width >= self.size.width{
                orbXShift = -1.0
            }
            
            orbNodePosition.x += 40.0 * orbXShift
            orbNodePosition.y += 120
            orbNode.position = orbNodePosition
            
            foregroundNode!.addChild(orbNode)
        }
    }
    
    //add black holes
    func addBlackHolesToForeground(){
        //movement variables
        let moveLeftAction = SKAction.moveToX(0.0, duration: 2.0)
        let moveRightAction = SKAction.moveToX(backgroundNode!.size.width, duration: 2.0)
        let actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
        let moveAction = SKAction.repeatActionForever(actionSequence)
        
        for i in 1...10 {
            
            let blackHoleNode = BlackHole()
            
            blackHoleNode.position = CGPointMake(size.width - 80.0, 600 * CGFloat(i))
            blackHoleNode.runAction(moveAction)
           
            foregroundNode!.addChild(blackHoleNode)
            
        }

    }
    
    override init(size: CGSize) {
        
        super.init(size: size)          // Pass size to superclass
        
        //link collision by delegate the Game scene
        physicsWorld.contactDelegate = self
        
        print("The size is (\(size.width), \(size.height))")
        
        //define world physics
        physicsWorld.gravity = CGVectorMake(0.0, -0.9)                      //sets gravity to a vector going down
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)  //sets background
        
        //adding the background
        backgroundNode = SKSpriteNode(imageNamed: BACKGROUND)       //create SKSpriteNode with image
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0)               //sets anchor point for background
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)     //sets position for background
        addChild(backgroundNode!)                                           //add background to the scene
        
        //adding background stars
        backgroundStars = SKSpriteNode(imageNamed: STARS)
        backgroundStars!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStars!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundStars!)

        //adding the planet
        planetBackground = SKSpriteNode(imageNamed: PLANET)
        planetBackground!.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        planetBackground!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(planetBackground!)
        
        //adding foreground
        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
        
        //add user input capabilities
        userInteractionEnabled = true
        
        //add the player from SpaceMan.swift in the foreground
        playerNode = SpaceMan()                                                 //create the player from SpaceMan.swift
        playerNode!.position = CGPoint(x: self.size.width / 2.0, y: 65.0)       //sets position for player
        foregroundNode!.addChild(playerNode!)                                   //add player to the foreground
        
        //add ennemy
        addBlackHolesToForeground()
        
        //Power Ups Collection
        //add power ups method call
        addOrbsToForeground()
        
        //Particles
        //add fire particle as engine at the bottom of the ship
        let engineExhaustPath = NSBundle.mainBundle().pathForResource("EngineExhaust", ofType: "sks")
        engineExhaust = NSKeyedUnarchiver.unarchiveObjectWithFile(engineExhaustPath!) as? SKEmitterNode
        engineExhaust!.position = CGPointMake(0.0, -(playerNode!.size.height / 2))
        
        playerNode!.addChild(engineExhaust!)
        engineExhaust!.hidden = true
        
        //display score
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.grayColor()
        scoreTextNode.position = CGPointMake(size.width - 10, size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        addChild(scoreTextNode)
        
        //display inpulse count
        impulseTextNode.text = "IMPULSES : \(impulseCount)"
        impulseTextNode.fontSize = 20
        impulseTextNode.fontColor = SKColor.grayColor()
        impulseTextNode.position = CGPointMake(10, size.height - 20)
        impulseTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(impulseTextNode)
        
        //add background music (BGM)
        //runAction(music01)
       
        //add start instruction
        startGameNode.text = "TAP ANYWHERE TO START!"
        startGameNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        startGameNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        startGameNode.fontSize = 20
        startGameNode.fontColor = SKColor.grayColor()
        startGameNode.position = CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
        addChild(startGameNode)

    }
    
    //User input method override
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let taps = event?.allTouches()
//        print(taps?.count)
        let tapType = taps?.count
        if !playerNode!.physicsBody!.dynamic{
            startGameNode.removeFromParent()
            playerNode!.physicsBody!.dynamic = true                         //resets physics
            
            self.coreMotionManager.accelerometerUpdateInterval = 0.3        //sets accelerometers updates
            
            self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMAccelerometerData?, error: NSError?) -> Void in
                if let _ = error{
                                        print("There was an error")
                                    }
                                    else{
                                        self.xAxisAcceleration = CGFloat(data!.acceleration.x)  //sets the x axis to the acceleration
                                    }

            })
//            self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(),
//                withHandler: {
//                (data: CMAccelerometerData!, error: NSError!) in
//                
//                if let constVar = error{
//                    print("There was an error")
//                }
//                else{
//                    self.xAxisAcceleration = CGFloat(data!.acceleration.x)  //sets the x axis to the acceleration
//                }
//            })
            
            /*if tapType == 1 {
                self.xAxisAcceleration = -0.2
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "xAxisBackToZero:", userInfo: nil, repeats: true)
            }
            else if tapType == 2 {
                self.xAxisAcceleration = 0.2
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "xAxisBackToZero:", userInfo: nil, repeats: true)
            }*/
        }
        
        if impulseCount > 0 {
            runAction(impulsePopAction)
            playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 10.0))   //going up when touches screen
            impulseCount--                                                  //decrease Impulse Count
            impulseTextNode.text = "IMPULSES : \(impulseCount)"             //update impulses display
            
            //show and hide engine burst
            engineExhaust!.hidden = false
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "hideEngineExhaust:", userInfo: nil, repeats: false)
            
        }
        
    }
    
    //collisions detections
    func didBeginContact(contact: SKPhysicsContact) {
        
        let nodeB = contact.bodyB.node!        //get a copy of node in contact with the player
        
        if nodeB.name == "POWER_UP_ORB" {       //test if the object in contact is the Power Up
            runAction(orbPopAction)             //execute an audio sound when contact with Power Up
            print("There has been contact with star.")      //method test
            impulseCount++                      //increment Impulse Count
            impulseTextNode.text = "IMPULSES : \(impulseCount)" //refresh impulse display
            
            score++                                 //increment score
            scoreTextNode.text = "SCORE : \(score)" //refresh score display
            
            nodeB.removeFromParent()            //delete the Power Up
        }
        else if nodeB.name == "BLACK_HOLE" {
            print("There has been contact with black hole.")
            runAction(blackHolePopAction)
            playerNode!.physicsBody!.contactTestBitMask = 0
            impulseCount = 0
            impulseTextNode.text = "GAME OVER !!!"
            for _ in 1...3 {
            let colorizeAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.5)
                playerNode!.runAction(colorizeAction)
            }
        }
    }
    
    //end collision detection
    func didEndContact(contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node!
        
        if nodeB.name == "POWER_UP_ORB"{
            print("Contac has ended with star.")
        }
        else if nodeB.name == "BLACK_HOLE"{
            print("Contact has ended with black hole.")
        }
    }
    
    //add scrolling background
    override func update(currentTime: NSTimeInterval) {
        //checking player position
        if playerNode != nil{
            if playerNode!.position.y >= 180 && playerNode!.position.y < 6400{
            
                //parallax scrolling
                //scrolling background
                backgroundNode!.position = CGPointMake(backgroundNode!.position.x, -((playerNode!.position.y - 180.0)/8))
                //scrolling planet
                planetBackground!.position = CGPointMake(planetBackground!.position.x, -((playerNode!.position.y - 180.0)/8))
                //scrolling background Stars
                backgroundStars!.position = CGPointMake(backgroundStars!.position.x, -((playerNode!.position.y - 180.0)/4))
                //scrolling foreground
                foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -(playerNode!.position.y - 180.0))
            }else if playerNode!.position.y > 7000.0 {
                gameOverWithResult(true)
            }else if playerNode!.position.y < 0.0{
                gameOverWithResult(false)
            }
        }
    }
    
    //add physics and player deplacements
    override func didSimulatePhysics() {
        if playerNode != nil {
            self.playerNode!.physicsBody!.velocity = CGVectorMake(self.xAxisAcceleration * 380.0, self.playerNode!.physicsBody!.velocity.dy)
        
            if playerNode!.position.x < -(playerNode!.size.width / 2){
            
                playerNode!.position = CGPointMake(size.width - playerNode!.size.width / 2, playerNode!.position.y)
            }
            else if self.playerNode!.position.x > self.size.width{
            
                playerNode!.position = CGPointMake(playerNode!.size.width / 2, playerNode!.position.y)
            }
        }
    }
    
    //turn of accelerometer when finished
    deinit{
        self.coreMotionManager.stopAccelerometerUpdates()
    }
    
    //xAxisAcceleration Control
    func xAxisBackToZero(timer:NSTimer!){
        if self.xAxisAcceleration != 0.0 {
            self.xAxisAcceleration = 0.0
        }
    }
    
    
    //Hide engine exhaust function
    func hideEngineExhaust(timer:NSTimer!){
        if !engineExhaust!.hidden{
            engineExhaust!.hidden = true
        }
    }
    
    //end of game function
    func gameOverWithResult(gameResult:Bool){
        playerNode!.removeFromParent()
        playerNode = nil
        
        if gameResult{
            print("YOU WON !!!")
        }else{
            print("YOU LOSE !!")
        }
        
        let transition = SKTransition.crossFadeWithDuration(2.0)
        let menuScene = MenuScene(size: size, gameResult: gameResult, score: score)
        view?.presentScene(menuScene, transition: transition)
    }
}
