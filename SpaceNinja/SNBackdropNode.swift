//
//  SNBackdropNode.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/17/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import SpriteKit

class SNBackdropNode: SKSpriteNode {
    
    let backdrop1 = SKSpriteNode(imageNamed: "space-bg.jpg")
    let backdrop2 = SKSpriteNode(imageNamed: "space-bg.jpg")
    var backdropBounds = CGRectZero
    
    internal func resetBackdropPositions(bounds:CGRect){
        backdrop1.position = CGPoint(x:0.0, y:(bounds.size.height))
        backdrop2.position = bounds.origin
    }
    
    init(frame:CGRect) {
        super.init(texture:nil, color: UIColor.blackColor(), size:frame.size)
        
        self.backdropBounds = frame
        
        self.addChild(backdrop1)
        self.addChild(backdrop2)
        
        self.resetBackdropPositions(self.backdropBounds)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    func didBackdropMove(){
        //var pos1 = backdrop1.position
        backdrop1.position.y--
        backdrop2.position.y--
        //var pos2 = backdrop2.position
        
        //pos1.y--;
        //pos2.y--;
        
        //backdrop1.position = pos1;
        //backdrop2.position = pos2;
        
        if (backdrop1.position.y <= 0.0){
            self.resetBackdropPositions(self.backdropBounds)
        }
    }
}