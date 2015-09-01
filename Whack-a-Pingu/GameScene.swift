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
    }
    
    func createSlotAt(pos: CGPoint) {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}
