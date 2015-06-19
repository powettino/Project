//
//  Speedo.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 09/03/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import SpriteKit
import QuartzCore

protocol ScoreDelegate{
    func setPoint();
    func setFail();
}


class Speedo : SKScene, SKPhysicsContactDelegate{
    
    struct PhysicsCategory {
        static let NeedleP : UInt32 = 0b1
        static let CollisionBlockP : UInt32 = 0b10
        static let Empty : UInt32 = 0b0
    }
    
    struct Needle{
        
        internal enum NeedleSpeed : NSTimeInterval{
            case fastest = 0.5
            case fast = 0.8
            case medium = 1
            case low = 1.5
        }
        
        var speed : NeedleSpeed!
        var movementAngles : (min: CGFloat, max: CGFloat)
        var collisionCategory : UInt32 = PhysicsCategory.NeedleP;
        var contactCollisionCategory  : UInt32 = PhysicsCategory.CollisionBlockP
        var collisionBitMask : UInt32 = PhysicsCategory.Empty
        var spriteNode : SKSpriteNode?
        var colliderNode : SKSpriteNode?
        var rotationLabel : String = "rotationAction"
        
        init(spriteName : String, posX : CGFloat, posY : CGFloat, posZ : CGFloat, name: String, startingAngle : Double, minAngle : Double, maxAngle : Double){
            speed = NeedleSpeed.low
            spriteNode = SKSpriteNode(imageNamed: spriteName);
            spriteNode!.name = name
            spriteNode!.position = CGPoint(x: posX, y: posY)
            spriteNode!.anchorPoint = CGPoint(x: 0.5, y: 0.1)
            spriteNode!.zRotation = Speedo.degreesToRadiant(startingAngle)
            spriteNode!.zPosition = posZ;
            movementAngles.min = Speedo.degreesToRadiant(minAngle)
            movementAngles.max = Speedo.degreesToRadiant(maxAngle)
            
            var colliderWidth : CGFloat = 10;
            var colliderHeight : CGFloat = 10;
            
            colliderNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: colliderWidth, height: colliderHeight))
            colliderNode!.name = name+"Collider";
            var punto = Speedo.findXY(spriteNode!.size.height + 30 , centerX: posX, centerY: posY, angle: Speedo.degreesToRadiant(90));
            colliderNode!.position = CGPoint(x: punto.x-spriteNode!.position.x, y: punto.y-spriteNode!.position.y)
            colliderNode!.zPosition = posZ;
            colliderNode!.physicsBody = SKPhysicsBody(circleOfRadius: colliderWidth/2-7)
            colliderNode!.physicsBody?.categoryBitMask = collisionCategory;
            colliderNode!.physicsBody?.contactTestBitMask = contactCollisionCategory;
            colliderNode!.physicsBody?.collisionBitMask = collisionBitMask
            colliderNode!.physicsBody?.dynamic = true;
            colliderNode!.physicsBody?.usesPreciseCollisionDetection = true;
            
            spriteNode?.addChild(colliderNode!);
        }
        
        mutating func setSpeed(newSpeed : NeedleSpeed){
            speed = newSpeed;
        }
        
        mutating func increaseSpeedTo(value: CGFloat){
            spriteNode!.runAction(SKAction.speedTo(value, duration: 0.5));
        }
        
        mutating func setStartPosition(startingAngle : Double){
            spriteNode!.zRotation = Speedo.degreesToRadiant(startingAngle)
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
    
    struct YellowSection {
        var referenceAngles : (angles: (max: CGFloat, min: CGFloat, dim: CGFloat), radius : CGFloat)!
        var yellowShape : SKShapeNode?
        var yellowName : String!
        var colliderNode : SKSpriteNode?
        var centerPoint : (x: CGFloat, y: CGFloat)
        
        init(startingLevel: Int, minDegree : Double, maxDegree : Double, centerX: CGFloat, centerY: CGFloat, rad: CGFloat, yellowSectionName : String){
            referenceAngles = (YellowSection.calcAngleOnLevel(startingLevel, minDegreeAngle: minDegree, maxDegreeAngle: maxDegree), rad);
            centerPoint.x = centerX;
            centerPoint.y = centerY;
            yellowName = yellowSectionName;
            updateNodes()
        }
        
        mutating func updateSection(level: Int, refMinDegree : Double, refMaxDegree : Double, radius : CGFloat){
            referenceAngles = (YellowSection.calcAngleOnLevel(level, minDegreeAngle: refMinDegree, maxDegreeAngle: refMaxDegree), radius);
            updateNodes();
        }
        
        mutating func updateNodes(){
            var pathToDraw = CGPathCreateMutable()
            
            CGPathMoveToPoint(pathToDraw, nil, centerPoint.x, centerPoint.y)
            CGPathAddArc(pathToDraw, nil, centerPoint.x, centerPoint.y, referenceAngles.radius, referenceAngles.angles.max, referenceAngles.angles.min, true);
            
            CGPathAddLineToPoint(pathToDraw, nil, centerPoint.x, centerPoint.y)
            yellowShape = SKShapeNode(path:pathToDraw)
            yellowShape!.name = yellowName;
            yellowShape!.path = pathToDraw
            yellowShape!.strokeColor = SKColor.orangeColor()
            yellowShape!.glowWidth = 0.6
            yellowShape!.fillColor = SKColor.orangeColor().colorWithAlphaComponent(0.6);
            
            var offset : CGFloat = 0;
            var punto = Speedo.findXY(referenceAngles.radius-offset, centerX: centerPoint.x, centerY: centerPoint.y, angle: referenceAngles.angles.max);
            var corda = (2  * (referenceAngles.radius-offset)) * (sin(referenceAngles.angles.dim/2));
            
            colliderNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: corda, height: 10));
            colliderNode!.name = yellowName+"Collider";
            colliderNode!.position = CGPoint(x: punto.x, y: punto.y);
            colliderNode!.anchorPoint = CGPoint(x: 0, y: 1);
            colliderNode!.zRotation = (referenceAngles.angles.max - (referenceAngles.angles.dim/2)) - Speedo.degreesToRadiant(90)
            colliderNode!.physicsBody = SKPhysicsBody(rectangleOfSize: colliderNode!.frame.size)
            colliderNode!.physicsBody?.categoryBitMask = PhysicsCategory.CollisionBlockP
            colliderNode!.physicsBody?.contactTestBitMask = PhysicsCategory.NeedleP
            colliderNode!.physicsBody?.collisionBitMask = PhysicsCategory.Empty;
            colliderNode!.physicsBody?.dynamic=false;
            colliderNode!.physicsBody?.usesPreciseCollisionDetection=true;
            yellowShape?.addChild(colliderNode!)
        }
        
        private static func calcAngleOnLevel(level : Int, minDegreeAngle : Double, maxDegreeAngle: Double) -> (max : CGFloat, min : CGFloat, dim : CGFloat){
            
            // si applica una correzione di 90 gradi dovuta agli assi del piano di presentazione
            // NSLog("Calcolo dai punti di riferimento: \(minDegreeAngle+90) - \(maxDegreeAngle+90)");
            var fixedAngles : (min: Double, max: Double) = (minDegreeAngle + 90, maxDegreeAngle + 90)
            var dimensionAngle = (fixedAngles.max - fixedAngles.min) / Double((level + 7))
            
            //NSLog("Dimensione angolo: \(dimensionAngle) - minimo: \( fixedAngles.min )");
            dimensionAngle = dimensionAngle < Speedo.minSectionDimension ? Speedo.minSectionDimension : dimensionAngle;
            
            var rnd: Double = Speedo.randomDouble( (fixedAngles.min + dimensionAngle),  max: (fixedAngles.max))
            //NSLog("Punto random: \(rnd)");
            
            return ( Speedo.degreesToRadiant(rnd), Speedo.degreesToRadiant(rnd-dimensionAngle), Speedo.degreesToRadiant(dimensionAngle));
        }
    }
    
    private static func degreesToRadiant(angle : Double) -> CGFloat{
        return CGFloat(angle * (M_PI / 180));
    }
    
    private static func radiansToDegrees (value:CGFloat) -> Double {
        return Double((value * 180)) / M_PI;
    }
    
    private static func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (x: CGFloat, y: CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
    
    private static func randomDouble(min : Double , max : Double) -> Double{
        return (Double(arc4random())) / Double(UINT32_MAX) * (max-min) + min
    }
    
    private final let yellowSectionShapeName : String = "yellowNode"
    private final let gridNodeName :String = "gridNode"
    private final let needleNodeName : String = "needleNode"
    
    private var enableFail = false;
    
    private let minDegreeNeedleAngle : Double = -136   //-46
    private let maxDegreeNeedleAngle : Double = 136   //226
    private let radius : CGFloat = 132;
    private var currentLevel : Int = 1
    private var colliso : Bool = false;
    private var running : Bool = false
    
    private var grid : SKSpriteNode!
    private var needle : Needle!
    private var yellowSection : YellowSection!
    private var maxAngle : CGFloat!
    private var minAngle : CGFloat!
    private static var minSectionDimension : Double = 10;
    private var centerX : CGFloat!;
    private var centerY : CGFloat!;
    
    var scoreDelegate : ScoreDelegate?
    
    func setNeedleSpeed(speed : Needle.NeedleSpeed){
        self.needle.setSpeed(speed);
    }
    
    func increaseSpeedTo(value : CGFloat){
        self.needle.increaseSpeedTo(value);
    }
    
    func enableFailDelegate(enable : Bool){
        self.enableFail = enable;
    }
    
    func startGame(){
        self.needle.startRotation();
        self.running=true;
        NSLog("velocita: \(self.needle.speed.rawValue)");
    }
    
    //    func didBeginContact(contact: SKPhysicsContact) {
    //        var firstBody: SKPhysicsBody
    //        var secondBody: SKPhysicsBody
    //        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
    //            firstBody = contact.bodyA
    //            secondBody = contact.bodyB
    //        } else {
    //            firstBody = contact.bodyB
    //            secondBody = contact.bodyA
    //        }
    //
    //        if ((firstBody.categoryBitMask & PhysicsCategory.NeedleP != 0) &&
    //            (secondBody.categoryBitMask & PhysicsCategory.CollisionBlockP != 0)) {
    //                NSLog("Vera collisione");
    //        }
    //        self.colliso=true;
    //    }
    
    //    func didEndContact(contact: SKPhysicsContact) {
    //        NSLog("Finito");
    //        self.colliso = false;
    //    }
    
    override func didMoveToView(view: SKView) {
        
        self.centerX = self.size.width/2;
        self.centerY = self.size.height/2;
        
        self.grid = SKSpriteNode(imageNamed: "primaprova.png");
        self.grid.name = self.gridNodeName;
        self.grid.position = CGPoint(x: self.centerX, y: self.centerY)
        self.grid.size = CGSize(width: 300, height: 300);
        
        self.grid.physicsBody = nil;
        self.addChild(self.grid)
        
        self.needle = Needle(spriteName: "ago4", posX: self.centerX, posY: self.centerY, posZ: CGFloat(1), name: self.needleNodeName, startingAngle: maxDegreeNeedleAngle, minAngle:minDegreeNeedleAngle, maxAngle: maxDegreeNeedleAngle);
        
        self.yellowSection = YellowSection(startingLevel: 1, minDegree: self.minDegreeNeedleAngle, maxDegree: self.maxDegreeNeedleAngle, centerX: self.centerX, centerY: self.centerY, rad: self.radius, yellowSectionName: self.yellowSectionShapeName);
        
        if let needleNode = self.needle.spriteNode {
            self.addChild(needleNode);
        }
        
        if let  yellowNode = self.yellowSection.yellowShape {
            self.addChild(yellowNode);
        }
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
    }
    
    func stopNeedle(){
        self.running=false;
        self.needle.stopRotation();
    }
    
    func resetSpeedo(){
        NSLog("needle : \(self.running)")
        //        if(self.running){
        self.stopNeedle();
        self.needle.increaseSpeedTo(1.0);
        self.needle.setStartPosition(maxDegreeNeedleAngle)
        self.currentLevel = 1;
        self.updateCollisionSection(self.currentLevel);
        //        }
    }
    
    func pauseNeedle(paused: Bool){
        self.needle.pauseRotation(paused)
    }
    
    func setLevel(level: Int){
        self.currentLevel = level;
    }
    
    func updateCollisionSection(level : Int?){
        if let tempLevel = level{
            self.setLevel(tempLevel);
        }
        for (obj) in self.children{
            if(self.yellowSectionShapeName == obj.name){
                obj.removeFromParent();
            }
        }
        
        self.yellowSection.updateSection(self.currentLevel, refMinDegree: self.minDegreeNeedleAngle, refMaxDegree: self.maxDegreeNeedleAngle, radius : self.radius);
        self.addChild(self.yellowSection.yellowShape!);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(self.running){
            if(self.colliso){
                self.colliso = false;
                self.currentLevel++;
                self.scoreDelegate?.setPoint();
            }else if(self.enableFail){
                self.scoreDelegate?.setFail();
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var intersecato = self.needle.colliderNode!.intersectsNode(self.yellowSection.colliderNode!);
        if(intersecato && !self.colliso){
            self.colliso = true;
        }
        if(!intersecato && self.colliso){
            self.colliso=false;
        }
    }
    
    func isMinimunSectionDimension() -> Bool{
        return (self.yellowSection.referenceAngles.angles.dim == Speedo.degreesToRadiant(Speedo.minSectionDimension));
    }
}