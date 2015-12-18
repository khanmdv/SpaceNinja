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
    
    let MAX_ALIEN_SPEED:CGFloat = 2.0
    let MIN_ALIEN_SPEED:CGFloat = 8.0
    
    
    var weapons = Array<SNWeapon>()
    var totalKills:Int = 0
    var totalMisses:Int = 0
    var lives:Int = SNConstants.MAX_LIVES
    var currentWeapon:SNWeapon? = nil
    var gameStartTime = NSDate()
    
    func getAlienSpeed() -> NSTimeInterval{
        let timeSinceGameStarted = NSDate().timeIntervalSinceDate(gameStartTime) * 0.005
        let speed = (MIN_ALIEN_SPEED - (CGFloat(timeSinceGameStarted) + (CGFloat(totalKills) * 0.1) - (CGFloat(totalMisses == 0 ? 1.0 : totalMisses) * 0.02)))
        print("Speed is \(speed)")
        
        if (speed < MAX_ALIEN_SPEED){
            return NSTimeInterval(MAX_ALIEN_SPEED)
        } else if (speed > MIN_ALIEN_SPEED){
            return NSTimeInterval(MIN_ALIEN_SPEED)
        } else {
            return NSTimeInterval(speed)
        }
    }
    
    func killMade(){
        totalKills++
    }
    
    func alienMissed(){
        print("Missed \(totalMisses)")
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
    
    func createWeaponNode(type:SNWeaponType, frame:CGRect) -> SKNode {
        let weaponNode = SKLabelNode(text:"L")
        weaponNode.position = CGPoint(x:random(min: 30, max: frame.size.width-30), y:frame.size.height)
        weaponNode.zPosition = 4
        weaponNode.fontSize = 60
        weaponNode.fontName = "chalkduster"
        weaponNode.fontColor = UIColor.greenColor()
        
        weaponNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width:30.0, height:60.0)) // 1
        weaponNode.physicsBody?.dynamic = true // 2
        weaponNode.physicsBody?.affectedByGravity = false
        weaponNode.physicsBody?.categoryBitMask = type == SNWeaponType.BattleGun ? PhysicsCategory.BattleGun : PhysicsCategory.LaserGun // 3
        weaponNode.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship // 4
        weaponNode.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        return weaponNode
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
