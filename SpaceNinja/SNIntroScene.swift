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

class SNIntroScene : SKScene {
    
    var backdropNode:SNBackdropNode? = nil
    var playButton:SKLabelNode? = nil
    var scoresButton:SKLabelNode? = nil
    
    /**
     *
     */
    override func didMoveToView(view: SKView) {
        // Add an infinite moving backdrop
        backdropNode = SNBackdropNode(frame: view.bounds)
        addChild(backdropNode!)
        
        // add game title
        self.addGameTitle(view)
        self.addNewGameButton(view)
        self.addScoresButton(view)
        self.addRotatingSpaceshipLogo(view)
        self.playIntroSoundLoop()
    }
    
    internal func addGameTitle(view: SKView){
        let gameTitle = SKLabelNode(fontNamed:SNConstants.ARCADE_FONT_NAME)
        gameTitle.text = SNConstants.APP_TITLE;
        gameTitle.fontColor = UIColor.greenColor()
        gameTitle.fontSize = 45;
        gameTitle.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 1.5)
        gameTitle.zPosition = 2
        self.addChild(gameTitle)
    }
    
    internal func addNewGameButton(view: SKView){
        playButton = SKLabelNode(fontNamed:SNConstants.ARCADE_FONT_NAME)
        playButton!.text = SNConstants.NEW_GAME_BUTTON_TITLE;
        playButton!.fontColor = UIColor.redColor()
        playButton!.fontSize = 30;
        playButton!.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 1.3)
        playButton!.zPosition = 2
        playButton!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        var borderSize = playButton!.frame.size
        borderSize.width += 20
        borderSize.height += 20
        let borderNode = SKShapeNode(rectOfSize:borderSize , cornerRadius: 4)
        playButton!.addChild(borderNode)
        self.addChild(playButton!)
    }
    
    internal func addScoresButton(view: SKView){
        scoresButton = SKLabelNode(fontNamed:SNConstants.ARCADE_FONT_NAME)
        scoresButton!.text = SNConstants.SCORES_BUTTON_TITLE;
        scoresButton!.fontColor = UIColor.redColor()
        scoresButton!.fontSize = 30;
        scoresButton!.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 1.1)
        scoresButton!.zPosition = 2
        scoresButton!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        var borderSize = playButton!.frame.size
        borderSize.width += 20
        borderSize.height += 20
        let borderNode = SKShapeNode(rectOfSize:borderSize , cornerRadius: 4)
        scoresButton!.addChild(borderNode)
        self.addChild(scoresButton!)
    }
    
    internal func addRotatingSpaceshipLogo(view: SKView){
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.position = CGPoint(x:CGRectGetMidX(view.frame), y:CGRectGetMidY(view.frame) * 0.6)
        sprite.xScale = 0.5
        sprite.yScale = 0.5
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
    
    
    /* Handle Touches */
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.locationInNode(self)
            
            if (playButton!.containsPoint(loc)){
                let gameScene = SNGameScene(size: view!.bounds.size)
                self.view?.presentScene(gameScene)
            }
        }
    }
}
