//
//  Needle.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 05/08/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import QuartzCore

struct Needle{
    
    internal enum NeedleSpeed : NSTimeInterval{
        case fastest = 0.5
        case fast = 0.8
        case medium = 1
        case low = 1.5
    }
    
    var speed : NeedleSpeed!
    var movementAngles : (min: CGFloat, max: CGFloat)
//    var collisionCategory : UInt32 = PhysicsCategory.NeedleP;
//    var contactCollisionCategory  : UInt32 = PhysicsCategory.CollisionBlockP
//    var collisionBitMask : UInt32 = PhysicsCategory.Empty
    var spriteNode : SKSpriteNode?
    var colliderNode : SKSpriteNode?
    var rotationLabel : String = "rotationAction"
    
    init(spriteName : String, w: CGFloat, maxH:CGFloat, posX : CGFloat, posY : CGFloat, posZ : CGFloat, name: String, startingAngle : Double, minAngle : Double, maxAngle : Double, anchorPoint: CGPoint){
        speed = NeedleSpeed.low
        spriteNode = SKSpriteNode(imageNamed: spriteName);
        spriteNode!.name = name
        spriteNode!.position = CGPoint(x: posX, y: posY)
        spriteNode!.size = CGSize(width: w, height: maxH)
        spriteNode!.anchorPoint = anchorPoint
        spriteNode!.zRotation = UtilityFunction.degreesToRadiant(startingAngle)
        spriteNode!.zPosition = posZ;
        movementAngles.min = UtilityFunction.degreesToRadiant(minAngle)
        movementAngles.max = UtilityFunction.degreesToRadiant(maxAngle)
        
        var colliderWidth : CGFloat = 10;
        var colliderHeight : CGFloat = 10;
        
        colliderNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: colliderWidth, height: colliderHeight))
        colliderNode!.name = name+"Collider";
        var punto = UtilityFunction.findXY(maxH , centerX: posX, centerY: posY, angle: UtilityFunction.degreesToRadiant(90));
        colliderNode!.position = CGPoint(x: punto.x-spriteNode!.position.x, y: punto.y - spriteNode!.position.y)
        colliderNode!.zPosition = posZ;
        //            colliderNode!.physicsBody = SKPhysicsBody(circleOfRadius: colliderWidth/2 - 7)
        //            colliderNode!.physicsBody?.categoryBitMask = collisionCategory;
        //            colliderNode!.physicsBody?.contactTestBitMask = contactCollisionCategory;
        //            colliderNode!.physicsBody?.collisionBitMask = collisionBitMask
        //            colliderNode!.physicsBody?.dynamic = true;
        //            colliderNode!.physicsBody?.usesPreciseCollisionDetection = true;
        
        spriteNode?.addChild(colliderNode!);
    }
    
    mutating func setSpeed(newSpeed : NeedleSpeed){
        speed = newSpeed;
    }
    
    mutating func increaseSpeedTo(value: CGFloat){
        spriteNode!.runAction(SKAction.speedTo(value, duration: 0.5));
    }
    
    mutating func setStartPosition(startingAngle : Double){
        spriteNode!.zRotation = UtilityFunction.degreesToRadiant(startingAngle)
    }
    
    mutating func startRotation(){
        let forwardRotation = SKAction.rotateToAngle(movementAngles.min, duration: speed.rawValue, shortestUnitArc: false);
        let backwardRotation = SKAction.rotateToAngle(movementAngles.max, duration: speed.rawValue, shortestUnitArc: false);
        var seq = SKAction.sequence([forwardRotation, backwardRotation]);
        spriteNode?.runAction(
            SKAction.repeatActionForever(seq)
            , withKey: rotationLabel
        );
    }
    
    mutating func pauseRotation(paused: Bool){
        spriteNode?.paused = paused;
    }
    
    mutating func stopRotation(){
        spriteNode?.removeActionForKey(rotationLabel)
    }
}