//
//  SNWeapon.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/18/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

enum SNWeaponType:Int { case BattleGun = 1, LaserGun }

protocol SNWeapon {
    
    func getWeaponType() -> SNWeaponType
    
    func getWeaponName() -> String
    
    func getRemainingRounds() -> Int
    
    func fire(scene:SNGameScene, from:CGPoint, to:CGPoint)
}