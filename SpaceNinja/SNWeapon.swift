//
//  SNWeapon.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/18/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

protocol SNWeapon {
    
    func getWeaponName() -> String
    
    func fire(scene:SNGameScene, from:CGPoint, to:CGPoint)
}