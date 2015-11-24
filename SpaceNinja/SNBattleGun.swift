//
//  SNBattleGun.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/21/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNBattleGun : SNWeapon {

    let MAX_SHOTS = INT32_MAX
    var shotsFired = 0
    
    func getWeaponName() -> String {
        return "Battle Gun"
    }
    
    func fire(scene:SNGameScene, from:CGPoint, to:CGPoint) {
        let touchLocation = to
        
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.zPosition = 3
        bullet.position = from
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1.0, height: 1.0))
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - bullet.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.y < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        scene.addChild(bullet)
        
        shotsFired++;
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + bullet.position
        
        // Calculate the angle of the bullet
        let rotationAngle = asin(offset.x/offset.length())
        bullet.zRotation = CGFloat(-rotationAngle)
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        let bulletSoundAction = SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false)
        bullet.runAction(SKAction.sequence([bulletSoundAction, actionMove, actionMoveDone]))
    }
}
