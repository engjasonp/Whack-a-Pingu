//
//  GameScene.swift
//  Whack-a-Pingu
//
//  Created by Jason Eng on 8/30/15.
//  Copyright (c) 2015 EngJason. All rights reserved.
//

import SpriteKit

var slots = [WhackSlot]()
var gameScore: SKLabelNode!
var score: Int = 0 {
    didSet {
        gameScore.text = "Score: \(score)"
    }
}
var popupTime = 0.85
var numRounds = 0

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .Left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }
        
        runAfterDelay(1) { [unowned self] in
            self.createEnemy()
        }
    }
    
    func createSlotAt(pos: CGPoint) {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        ++numRounds
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            addChild(gameOver)
            
            return
        }
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {    slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)    }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        runAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let nodes = nodesAtPoint(location) as! [SKNode]
        
        for node in nodes {
            if node.name == "charFriend" {
                let whackSlot = node.parent!.parent as! WhackSlot
                if !whackSlot.visible { continue }
                if whackSlot.isHit { continue }
                
                whackSlot.hit()
                score -= 5
                
                runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
            } else if node.name == "charEnemy" {
                let whackSlot = node.parent!.parent as! WhackSlot
                if !whackSlot.visible { continue }
                if whackSlot.isHit { continue }
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                whackSlot.hit()
                ++score
                
                runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}
