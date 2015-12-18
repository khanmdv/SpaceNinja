//
//  SNTextures.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/22/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNTextures {
    
    static var alienTexture1:SKTexture = SKTexture(imageNamed: "Alien1")
    static var alienTexture2:SKTexture = SKTexture(imageNamed: "Alien2")
    static var laserTexture:SKTexture  = SKTexture(imageNamed: "Laser")
    static var bulletTexture:SKTexture = SKTexture(imageNamed: "Bullet")
    static var forceFieldTexture:SKTexture = SKTexture(imageNamed: "ForceField")
    
    static var texturesLoaded:Bool = false
    
    static func loadTexturesWithCompletion(completion:() -> Void){
        SKTexture.preloadTextures([
            alienTexture1,
            alienTexture2,
            laserTexture,
            bulletTexture,
            forceFieldTexture
        ]) { () -> Void in
            texturesLoaded = true
            completion();
        }
    }
}
