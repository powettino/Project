//
//  GameScene.swift
//  Prova
//
//  Created by Iacopo Peri on 06/02/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
//

import SpriteKit

let contak = SKSpriteNode(imageNamed: "conta")
let lancetta = SKSpriteNode(imageNamed: "lanc")
var toccato = false;
var b = SKSpriteNode()

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let boh   : UInt32 = 0b1       // 1
    static let lan: UInt32 = 0b10      // 2
}

class GameScene: SKScene , SKPhysicsContactDelegate{
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        contak.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        lancetta.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        lancetta.setScale(0.5)
        
        
        b  = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(lancetta.size.width, lancetta.size.height))
        b.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        b.setScale(0.5)
        self.addChild(b)
        
        
        // self.addChild(contak)
        self.addChild(lancetta)
        
        var Circle = SKShapeNode(circleOfRadius: 10)
        Circle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        Circle.name = "defaultCircle"
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 10.0
        Circle.fillColor = SKColor.yellowColor()
        Circle.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        Circle.physicsBody?.dynamic = false //set to false so it doesn't fall off scene.
        Circle.physicsBody?.categoryBitMask = PhysicsCategory.boh // 3
        Circle.physicsBody?.contactTestBitMask = PhysicsCategory.lan // 4
        Circle.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        Circle.physicsBody?.usesPreciseCollisionDetection = true
        Circle.physicsBody?.applyImpulse(CGVector(dx: 0.2, dy: 0.5))
        Circle.physicsBody?.applyTorque(CGFloat(0.3))
        self.addChild(Circle)
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        self.physicsBody?.velocity = CGVector(dx: 1, dy: 0);
      
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        //        for touch: AnyObject in touches {
        //            let location = touch.locationInNode(self)
        //
        //            let sprite = SKSpriteNode(imageNamed:"conta")
        //
        //            sprite.xScale = 0.5
        //            sprite.yScale = 0.5
        //            sprite.position = location
        //
        //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //
        //            sprite.runAction(SKAction.repeatActionForever(action))
        //
        //            self.addChild(sprite)
        //        }
        if(!toccato){
            let andata = SKAction.rotateToAngle(CGFloat((270/360) * M_PI), duration: 0.75, shortestUnitArc: true)
            let ritorno = SKAction.rotateToAngle(CGFloat(0), duration: 0.75)
            b.anchorPoint = CGPoint(x:0.5,y:0.3)
            lancetta.anchorPoint = CGPoint(x:0.48,y:0.37)
            lancetta.physicsBody = SKPhysicsBody(rectangleOfSize: lancetta.size)
            lancetta.physicsBody!.dynamic = true // 2
            lancetta.physicsBody!.categoryBitMask = PhysicsCategory.lan // 3
            lancetta.physicsBody!.contactTestBitMask = PhysicsCategory.boh // 4
            lancetta.physicsBody!.collisionBitMask = PhysicsCategory.None // 5
            lancetta.physicsBody!.velocity = CGVector(dx: 1, dy: 0)
            lancetta.physicsBody!.applyTorque(CGFloat(3))
        lancetta.runAction(SKAction.repeatActionForever(SKAction.sequence([andata, ritorno])));
            b.runAction(SKAction.repeatActionForever(SKAction.sequence([andata, ritorno])));
        }else{
            lancetta.removeAllActions()
            
        }
        
        toccato = !toccato
        
    }
    
    
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
    }
   
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
