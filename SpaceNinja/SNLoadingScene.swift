//
//  SNIntroScene.swift
//  SpaceNinja
//
//  Created by Mohtashim Khan on 11/17/15.
//  Copyright © 2015 Mohtashim Khan. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SNLoadingScene : SKScene {
    
    var backdropNode:SNBackdropNode? = nil
    
    /**
     *
     */
    override func didMoveToView(view: SKView) {
        // Add an infinite moving backdrop
        backdropNode = SNBackdropNode(frame: view.bounds)
        addChild(backdropNode!)
        
        // add game title
        self.addLoadingIndicator(view)
        self.addRotatingSpaceshipLogo(view)
        self.playIntroSoundLoop()
    }
    
    internal func addLoadingIndicator(view: SKView){
        let gameTitle = SKLabelNode(fontNamed:SNConstants.ARCADE_FONT_NAME)
        gameTitle.text = SNConstants.NOW_LOADING_TEXT;
        gameTitle.fontColor = UIColor.greenColor()
        gameTitle.fontSize = 30;
        gameTitle.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 1.3)
        gameTitle.zPosition = 2
        self.addChild(gameTitle)
    }
    
    internal func addRotatingSpaceshipLogo(view: SKView){
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 1.0)
        sprite.xScale = 0.3
        sprite.yScale = 0.3
        sprite.zPosition = 2
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        
        addChild(sprite)
    }
    
    internal func playIntroSoundLoop(){
        let backgroundMusic = SKAudioNode(fileNamed: "intro.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    /**
     * We use this method to implement infinite scrolling background
     */
    override func update(currentTime: NSTimeInterval) {
        backdropNode!.didBackdropMove();
    }
}
