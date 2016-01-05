//
//  SNGameScene.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/17/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNGameScene : SKScene, SKPhysicsContactDelegate {
    
    var backdropNode:SNBackdropNode? = nil
    let gamePlay:SNGamePlay = SNGamePlay()
    var duration = NSTimeInterval(1.0)
    var currentWeaponLabel:SKLabelNode = SKLabelNode()
    var weaponRoundsRemainingLabel:SKLabelNode = SKLabelNode()
    var gamePaused:Bool = false
    var spaceshipShieldVisible:Bool = false
    var spaceship:SKNode? = nil
    var touchOnSpaceship:Bool = false
    var timeToAddNewWeapon:NSTimeInterval = 0.0
    
    /**
     *
     */
    override func didMoveToView(view: SKView) {
        // Add an infinite moving backdrop
        backdropNode = SNBackdropNode(frame: view.bounds)
        addChild(backdropNode!)
        
        //physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addAxisLine(view)
        addSpaceShip(view)
        addWeaponLabels(view)
        gamePlay.addDefaultWeapon()
        timeToAddNewWeapon = NSTimeInterval(random(min: 5.0, max: 15.0))
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addAlien),
            SKAction.waitForDuration(1.0),
            SKAction.runBlock(addWeapon)
            ]))
        )
    }
    
    func addSpaceShip(view:SKView){
        spaceship = gamePlay.createSpaceshipInView(view)
        addChild(spaceship!)
    }
    
    func addAxisLine(view:SKView){
        let yPos:CGFloat = CGRectGetMidY(view.frame) * 0.15
        let lineNode = SKShapeNode()
        
        let linePath:CGMutablePath? = CGPathCreateMutable();
        CGPathMoveToPoint(linePath!, nil, 0.0, yPos)
        CGPathAddLineToPoint(linePath!, nil, view.frame.size.width, yPos)
        lineNode.path = linePath!;
        lineNode.zPosition = 2
        
        lineNode.lineWidth = 2.0;
        lineNode.strokeColor = SKColor.redColor()
        lineNode.glowWidth = 2.0;
        
        addChild(lineNode)
    }
    
    func addWeaponLabels(view:SKView){
        let weaponNameLabel = SKLabelNode(text: SNConstants.WEAPON_NAME_TEXT)
        weaponNameLabel.fontSize = 12.0
        currentWeaponLabel.fontSize = 12.0
        weaponNameLabel.fontColor = UIColor.greenColor()
        currentWeaponLabel.fontColor = UIColor.redColor()
        
        weaponNameLabel.position = CGPoint(x: 30, y: CGRectGetMidY(view.frame) * 0.08)
        currentWeaponLabel.position = CGPoint(x:90, y : CGRectGetMidY(view.frame) * 0.08)
        
        weaponNameLabel.zPosition = 3
        currentWeaponLabel.zPosition = 3
        weaponNameLabel.fontName = "Helvetica"
        currentWeaponLabel.fontName = "Helvetica"
        
        addChild(weaponNameLabel)
        addChild(currentWeaponLabel)
        
        let weaponRoundsNameLabel = SKLabelNode(text: SNConstants.WEAPON_REMAINING_ROUNDS)
        weaponRoundsNameLabel.fontSize = 12.0
        weaponRoundsRemainingLabel.fontSize = 12.0
        weaponRoundsNameLabel.fontColor = UIColor.greenColor()
        weaponRoundsRemainingLabel.fontColor = UIColor.redColor()
        
        weaponRoundsNameLabel.position = CGPoint(x: 30, y: CGRectGetMidY(view.frame) * 0.03)
        weaponRoundsRemainingLabel.position = CGPoint(x:70, y : CGRectGetMidY(view.frame) * 0.03)
        
        weaponRoundsNameLabel.zPosition = 3
        weaponRoundsRemainingLabel.zPosition = 3
        weaponRoundsNameLabel.fontName = "Helvetica"
        weaponRoundsRemainingLabel.fontName = "Helvetica"
        addChild(weaponRoundsNameLabel)
        addChild(weaponRoundsRemainingLabel)
        
        if let weapon:SNWeapon? = gamePlay.getCurrentWeapon() {
            
            currentWeaponLabel.text = weapon!.getWeaponName()
            weaponRoundsRemainingLabel.text = String(weapon!.getRemainingRounds())
        }
        
    }
    
    func markAlienMissed(){
        gamePlay.alienMissed()
    }
    
    func addAlien(){
        if (gamePaused){
            return
        }
        
        let y = self.frame.size.height
        let alien = gamePlay.createAlien(self.frame.size)
        addChild(alien)
        alien.runAction(SKAction.sequence([
            SKAction.moveToY(-y, duration: gamePlay.getAlienSpeed()),
            SKAction.removeFromParent(),
            SKAction.runBlock(markAlienMissed)
        ]));
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addWeapon(){
        if (gamePaused){
            return
        }
        
        if (timeToAddNewWeapon > 0 || gamePlay.getCurrentWeapon().getRemainingRounds() > 20){
            timeToAddNewWeapon--
            return;
        }
        
        let y = self.frame.size.height
        let weaponNode = gamePlay.createWeaponNode(SNWeaponType.LaserGun, frame:self.frame)
        addChild(weaponNode)
        weaponNode.runAction(SKAction.sequence([
            SKAction.moveToY(-y, duration: 15),
            SKAction.removeFromParent()
            ]));
        
        timeToAddNewWeapon = NSTimeInterval(random(min: 5.0, max: 15.0))
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        if let sp = spaceship {
            if (sp.containsPoint(touchLocation)){
                touchOnSpaceship = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        if (touchOnSpaceship){
            spaceship?.position.x = touchLocation.x
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.locationInNode(self)
        
        if (touchOnSpaceship == true){
            touchOnSpaceship = false
            return
        }
        
        // Make sure we touch in the area above the spaceship
        if (touchLocation.y < spaceship?.position.y) { return }
        
        // 2 - Set up initial location of projectile
        if let weapon:SNWeapon = gamePlay.getCurrentWeapon() {
        
            weapon.fire(self, from:(spaceship?.position)!, to:touchLocation)
            currentWeaponLabel.text = weapon.getWeaponName()
            weaponRoundsRemainingLabel.text = String(weapon.getRemainingRounds())
        }
    }
    
    
    /**
     * We use this method to implement infinite scrolling background
     */
    override func update(currentTime: NSTimeInterval) {
        backdropNode!.didBackdropMove();
    }
    
    func newSmokeEmitter() -> SKEmitterNode
    {
        let smokePath = NSBundle.mainBundle().pathForResource("Fire", ofType: "sks")
        let smoke:SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(smokePath!) as! SKEmitterNode
        return smoke;
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("Contact Happened")
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        print("First BM = \(firstBody.categoryBitMask) Second BM = \(secondBody.categoryBitMask)")
        
        if ((secondBody.categoryBitMask & (PhysicsCategory.Bullet | PhysicsCategory.Laser) != 0) &&
            (firstBody.categoryBitMask & PhysicsCategory.Alien != 0)) {
                
            // Alien hit
            gamePlay.killMade()
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
                
        } else if ((secondBody.categoryBitMask & PhysicsCategory.Alien != 0) &&
            (firstBody.categoryBitMask & PhysicsCategory.Spaceship != 0) &&
            self.spaceshipShieldVisible == false) {
                
            gamePlay.alienCollision()
            print("Collision with alien")
            let smokeNode = newSmokeEmitter()
            smokeNode.position = (spaceship?.position)!;
            smokeNode.zPosition = 4
            gamePaused = true
            NSNotificationCenter.defaultCenter().postNotificationName("GAME_PAUSED", object: nil)
            addChild(smokeNode)
            smokeNode.runAction(SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(2.0)), SKAction.removeFromParent(), SKAction.runBlock({ () -> Void in

                self.spaceshipShieldVisible = true
                self.gamePaused = false
                NSNotificationCenter.defaultCenter().postNotificationName("GAME_RESUME", object: nil)
                
                
                let forceField = self.getForceField()
                forceField.position = (self.spaceship?.position)!
                forceField.zPosition = 4.0
                
                self.addChild(forceField)
                
                self.spaceship?.runAction(SKAction.sequence([
                        SKAction.fadeAlphaTo(0.5, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(0.5, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(0.5, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(0.5, duration: NSTimeInterval(0.5)),
                        SKAction.fadeAlphaTo(1.0, duration: NSTimeInterval(0.5))
                    ]))
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_global_queue(0, 0), { () -> Void in
                    self.spaceshipShieldVisible = false
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        forceField.removeFromParent()
                    })
                })
            })]))
        } else if ((secondBody.categoryBitMask & PhysicsCategory.BattleGun != 0) &&
            (firstBody.categoryBitMask & PhysicsCategory.Spaceship != 0)) {
                
                gamePlay.weaponChanged(SNBattleGun())
                
                if let weapon:SNWeapon = gamePlay.getCurrentWeapon() {
                    
                    currentWeaponLabel.text = weapon.getWeaponName()
                    weaponRoundsRemainingLabel.text = String(weapon.getRemainingRounds())
                }
        
        } else if ((secondBody.categoryBitMask & PhysicsCategory.LaserGun != 0) &&
            (firstBody.categoryBitMask & PhysicsCategory.Spaceship != 0)) {
                
                gamePlay.weaponChanged(SNLaserGun())
                if let weapon:SNWeapon = gamePlay.getCurrentWeapon() {
                    
                    currentWeaponLabel.text = weapon.getWeaponName()
                    weaponRoundsRemainingLabel.text = String(weapon.getRemainingRounds())
                }
                
        } else {
            print("Nothing happened")
        }
    }
    
    internal func getForceField() -> SKNode {
        let forceField:SKNode = SKSpriteNode(texture: SNTextures.forceFieldTexture)
        
        return forceField;
    }
}