//
//  OperatorsOverridden.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/22/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import UIKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Spaceship : UInt32 = 0b1      // 1
    static let Alien     : UInt32 = 0b10      // 2
    static let Bullet    : UInt32 = 0b100 // 4
    static let Laser     : UInt32 = 0b1000 // 8
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

extension CGSize {
    func length() -> CGFloat {
        return sqrt(width*width + height*height)
    }
}