//
//  SNBattleGun.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/21/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNLaserGun : SNWeapon {
    
    let MAX_SHOTS = 50
    var shotsFired = 0
    
    func getWeaponName() -> String {
        return "Laser Gun"
    }
    
    func getWeaponType() -> SNWeaponType {
        return SNWeaponType.LaserGun
    }
    
    func getRemainingRounds() -> Int {
        return MAX_SHOTS - shotsFired
    }
    
    func fire(scene:SNGameScene, from:CGPoint, to:CGPoint) {
        let touchLocation = to
        let bulletSize = CGSize(width: 8.0, height: 128.0)
        let bullet = SKSpriteNode(imageNamed: "Laser")
    
        bullet.zPosition = 1
        bullet.position = from
        bullet.anchorPoint = CGPoint(x:bullet.anchorPoint.x, y: 0)
        
        // Add physics body
        bullet.physicsBody = SKPhysicsBody(texture: SNTextures.laserTexture, size: bulletSize)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Laser
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
        
        // Calculate the angle of the bullet
        let rotationAngle = asin(offset.x/offset.length())
        bullet.zRotation = CGFloat(-rotationAngle)
        
        // We have to scale the laser
        
        // 9 - Create the actions
        let scaleAction = SKAction.scaleXBy(3.0, y: CGFloat(offset.length()/(bulletSize.length()/2)), duration: 0.2)
        let scaleActionDone = SKAction.removeFromParent()
        let bulletSoundAction = SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false)
        bullet.runAction(SKAction.sequence([bulletSoundAction, scaleAction, scaleActionDone]))
    }
}
