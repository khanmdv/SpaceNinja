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
    var spaceshipPosition:CGPoint = CGPointZero
    
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
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addAlien),
            SKAction.waitForDuration(duration)
            ]))
        )
    }
    
    func addSpaceShip(view:SKView){
        
        let spaceship = gamePlay.createSpaceshipInView(view)
        spaceshipPosition = spaceship.position
        addChild(spaceship)
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
    
    func addAlien(){
        let y = self.frame.size.height
        let alien = gamePlay.createAlien(self.frame.size)
        addChild(alien)
        alien.runAction(SKAction.sequence([
            SKAction.moveToY(-y, duration: gamePlay.getAlienSpeed()),
            SKAction.removeFromParent()
        ]));
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // Make sure we touch in the area above the spaceship
        if (touchLocation.y < spaceshipPosition.y) { return }
        
        // 2 - Set up initial location of projectile
        if let weapon:SNWeapon = gamePlay.getCurrentWeapon() {
        
            weapon.fire(self, from:spaceshipPosition, to:touchLocation)
        }
    }
    
    
    /**
     * We use this method to implement infinite scrolling background
     */
    override func update(currentTime: NSTimeInterval) {
        backdropNode!.didBackdropMove();
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
            (firstBody.categoryBitMask & PhysicsCategory.Spaceship != 0)) {
                
            gamePlay.alienCollision()
            print("Collision with alien")
        } else {
            print("Nothing happened")
        }
    }
}