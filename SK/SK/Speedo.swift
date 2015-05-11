//
//  Speedo.swift
//  SK
//
//  Created by Iacopo Peri on 07/03/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
//

import Foundation
import SpriteKit

class Speedo : SKScene {
    var lancetta : SKNode!
    var centro :SKNode!
    var empty : SKNode!
    var num1 : SKNode!
    var num2 : SKNode!
    var num3 : SKNode!
    
    override func didMoveToView(view: SKView) {
        centro = childNodeWithName("perno")
        lancetta = centro.childNodeWithName("ago")
        empty = lancetta.childNodeWithName("tappo")
        num1 = childNodeWithName("number1")
        num2 = childNodeWithName("number2")
        num3 = childNodeWithName("number3")
        num3.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures([
                SKTexture(imageNamed: "0.png"),
                SKTexture(imageNamed: "1.png"),
                SKTexture(imageNamed: "2.png")],
                timePerFrame: 0.1)))
        num2.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures([
                SKTexture(imageNamed: "0.png"),
                SKTexture(imageNamed: "1.png"),
                SKTexture(imageNamed: "2.png")],
                timePerFrame: 0.3)))
        num1.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures([
                SKTexture(imageNamed: "0.png"),
                SKTexture(imageNamed: "1.png"),
                SKTexture(imageNamed: "2.png")],
                timePerFrame: 0.6)))
        
    }
    
    func moveToTappo(p: CGPoint){
        let perc = min(1.0, p.x / self.frame.width)
        let speedup = SKAction.speedTo(perc, duration: 0.5)
        num1.runAction(speedup)
        num2.runAction(speedup)
        num3.runAction(speedup)
        let action = SKAction.reachTo(p, rootNode: lancetta, duration: 0.5)
        empty.runAction(action);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            moveToTappo(location)
        }
    }
}