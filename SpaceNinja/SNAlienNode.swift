//
//  SNAlienNode.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/18/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNAlienNode: SKSpriteNode {
    
    init(frame:CGRect) {
        super.init(texture:nil, color: UIColor.clearColor(), size:frame.size)
        
        if (SNTextures.texturesLoaded){
            self.addAlienNode(frame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    internal func addAlienNode(frame:CGRect){
        let alienNode = SKSpriteNode(texture: SNTextures.alienTexture1, color: UIColor.clearColor(), size: frame.size)
        alienNode.position = frame.origin
        alienNode.zPosition = 2
        
        alienNode.physicsBody = SKPhysicsBody(rectangleOfSize: alienNode.size) // 1
        alienNode.physicsBody?.dynamic = true // 2
        alienNode.physicsBody?.affectedByGravity = false
        alienNode.physicsBody?.categoryBitMask = PhysicsCategory.Alien // 3
        alienNode.physicsBody?.contactTestBitMask = PhysicsCategory.Spaceship | PhysicsCategory.Bullet | PhysicsCategory.Laser
        alienNode.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        addChild(alienNode)
        
        let action = SKAction.animateWithTextures([SNTextures.alienTexture1, SNTextures.alienTexture2], timePerFrame: 0.3)
        let repeatAction = SKAction.repeatActionForever(action)
        alienNode.runAction(repeatAction)
    }
}