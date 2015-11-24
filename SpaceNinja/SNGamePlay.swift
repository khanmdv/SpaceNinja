//
//  SNGamePlay.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/18/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNGamePlay {
    
    var weapons = Array<SNWeapon>()
    var totalKills:Int = 0
    var totalMisses:Int = 0
    var lives:Int = SNConstants.MAX_LIVES
    var currentWeapon:SNWeapon? = nil
    
    var alienSpeed:CGFloat = 8.0
    
    func getAlienSpeed() -> NSTimeInterval{
        if (totalKills == 0 || totalMisses == 0) {
            return NSTimeInterval(alienSpeed)
        } else {
            return NSTimeInterval((CGFloat)(totalMisses/totalKills) * alienSpeed)
        }
    }
    
    func killMade(){
        totalKills++
    }
    
    func alienMissed(){
        totalMisses++
    }
    
    func weaponChanged(newWeapon:SNWeapon){
        weapons.append(newWeapon)
        currentWeapon = newWeapon
    }
    
    func alienCollision(){
        lives--
    }
    
    func isPlayerAlive() -> Bool {
        return lives > 0
    }
    
    func getCurrentWeapon() -> SNWeapon {
        return currentWeapon!
    }
    
    func createAlien(size:CGSize) -> SKSpriteNode {
        let x = random(min:48, max:size.width-48)
        let y = size.height
        let alienNode = SNAlienNode(frame: CGRect(x: x, y: y, width: 48, height: 48))
        return alienNode;
    }
    
    func createSpaceshipInView(view:SKView) -> SKSpriteNode {
        let yPos:CGFloat = CGRectGetMidY(view.frame) * 0.15
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = CGPoint(x:CGRectGetMidX(view.frame), y:yPos)
        sprite.xScale = 0.4
        sprite.yScale = 0.4
        sprite.zPosition = 2
        
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size) // 1
        sprite.physicsBody?.dynamic = true // 2
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Spaceship // 3
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Alien // 4
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        self.addDefaultWeapon()
        
        return sprite
    }
    
    func addDefaultWeapon(){
        self.weaponChanged(SNBattleGun())
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
