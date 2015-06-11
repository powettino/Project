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

class Speedo : SKScene, SKPhysicsContactDelegate{
    
    struct PhysicsCategory {
        static let NeedleP : UInt32 = 0b1
        static let CollisionBlockP : UInt32 = 0b10
        static let Vuoto : UInt32 = 0b0
    }
    
    private static func degreesToRadiant(angle : Double) -> CGFloat{
        return CGFloat(angle * (M_PI / 180));
    }
    
    private static func radiansToDegrees (value:CGFloat) -> Double {
        return Double((value * 180)) / M_PI;
    }
    
    enum NeedleSpeed : NSTimeInterval{
        case fastest = 1
        case fast = 1.5
        case medium = 2
        case low = 2.5
    }
    
    private final let yellowSectionShapeName : String = "yellowSectionShape"
    private final let yellowCollisionNodeName : String = "yellowCollisionNode"
    private final let pernoCentraleNodeName : String = "pernoCentraleNode"
    private final let collisionNeedleNodeName : String = "collisionNeedleNode"
    private final let gridNodeName :String = "gridNode"
    private final let needleNodeName : String = "needleNode"
    
    internal let minDegreeNeedleAngle : Double = -136   //-46
    internal let maxDegreeNeedleAngle : Double = 136   //226
    private let radius : CGFloat = 132;
    private var currentLevel : Int = 1
    private var currentSpeed : NeedleSpeed!
    private var colliso : Bool = false;
    
    private var grid : SKSpriteNode!
    private var lancetta : SKSpriteNode!
    private var needleCollisionNode : SKSpriteNode!
    private var pernoCentrale : SKSpriteNode!
    private var nodoCollisione : SKSpriteNode!
    private var maxAngle : CGFloat!
    private var minAngle : CGFloat!
    private var minAngleYellowSection : Double = 10
    private var centerX : CGFloat!;
    private var centerY : CGFloat!;
    
    private func standardInit(){
        self.currentSpeed = NeedleSpeed.fast;
        
        self.maxAngle = Speedo.degreesToRadiant(maxDegreeNeedleAngle);
        self.minAngle = Speedo.degreesToRadiant(minDegreeNeedleAngle);
        
        self.grid = SKSpriteNode(imageNamed: "primaprova.png");
        self.grid.name = self.gridNodeName;
        self.grid.position = CGPoint(x: self.centerX, y: self.centerY)
        self.grid.size = CGSize(width: 300, height: 300);
        
        self.grid.physicsBody = nil;
        self.addChild(self.grid)
        
        self.lancetta = SKSpriteNode(imageNamed: "ago4");
        self.lancetta.name = self.needleNodeName
        self.lancetta.position = CGPoint(x: self.centerX, y: self.centerY)
        self.lancetta.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        self.lancetta.zRotation = maxAngle;
        self.lancetta.zPosition = 1;
        
        //        self.lancetta.physicsBody = SKPhysicsBody(rectangleOfSize: self.lancetta.frame.size);
        //        NSLog("Frame \(self.lancetta.frame.size) + \(self.lancetta.frame.origin)")
        //        self.lancetta.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ago4.png"), alphaThreshold: 1, size: self.lancetta.frame.size);
        //        self.lancetta.physicsBody?.categoryBitMask = PhysicsCategory.NeedleP;
        //        self.lancetta.physicsBody?.contactTestBitMask = PhysicsCategory.CollisionBlockP;
        //        self.lancetta.physicsBody?.collisionBitMask = PhysicsCategory.Vuoto
        //        //        self.lancetta.physicsBody?.affectedByGravity = false;
        //        //        self.lancetta.physicsBody?.allowsRotation = false;
        //        self.lancetta.physicsBody?.dynamic = true;
        //        self.lancetta.physicsBody?.usesPreciseCollisionDetection = true;
        self.addChild(self.lancetta);
        
        self.pernoCentrale = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 5, height: 5));
        self.pernoCentrale.name = self.pernoCentraleNodeName
        self.pernoCentrale.position = CGPoint(x: self.centerX, y: self.centerY)
        self.pernoCentrale.zPosition = 1;
        self.addChild(self.pernoCentrale);
        
        self.needleCollisionNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 10, height: 10))
        self.needleCollisionNode.name = self.collisionNeedleNodeName;
        var punto = findXY(self.radius-7, centerX: self.centerX, centerY: self.centerY, angle: Speedo.degreesToRadiant(self.minDegreeNeedleAngle));
        self.needleCollisionNode.position = CGPoint(x: punto.x-self.pernoCentrale.position.x, y: punto.y-self.pernoCentrale.position.y)
        self.needleCollisionNode.zPosition = 2;
        self.needleCollisionNode.physicsBody = SKPhysicsBody(circleOfRadius: self.needleCollisionNode.size.width/2);
        self.needleCollisionNode.physicsBody?.categoryBitMask = PhysicsCategory.NeedleP;
        self.needleCollisionNode.physicsBody?.contactTestBitMask = PhysicsCategory.CollisionBlockP;
        self.needleCollisionNode.physicsBody?.collisionBitMask = PhysicsCategory.Vuoto
        self.needleCollisionNode.physicsBody?.dynamic = true;
        self.needleCollisionNode.physicsBody?.usesPreciseCollisionDetection = true;
        self.pernoCentrale.addChild(self.needleCollisionNode);
        
    }
    
    func setNeedleSpeed(speed : NeedleSpeed){
        self.currentSpeed = speed;
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        NSLog("Colliso \(contact.bodyA.categoryBitMask) - \(contact.bodyB.categoryBitMask)");
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.NeedleP != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.CollisionBlockP != 0)) {
                NSLog("Vera collisione");
        }
        self.colliso=true;
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        NSLog("Finito");
        self.colliso = false;
    }
    
    override func didMoveToView(view: SKView) {
        
        
        self.centerX = self.size.width/2;
        self.centerY = self.size.height/2;
        standardInit()
        
        let rotazioneNeedleA = SKAction.rotateToAngle(minAngle, duration: self.currentSpeed.rawValue, shortestUnitArc: false);
        let rotazioneNeedleB = SKAction.rotateToAngle(maxAngle, duration: self.currentSpeed.rawValue, shortestUnitArc: false);
        
        let rotazionePernoA = SKAction.rotateToAngle(Speedo.degreesToRadiant(-270), duration: self.currentSpeed.rawValue, shortestUnitArc: false);
        let rotazionePernoB = SKAction.rotateToAngle(Speedo.degreesToRadiant(0), duration: self.currentSpeed.rawValue, shortestUnitArc: false);
        
        
        var seq = SKAction.sequence([rotazioneNeedleA, rotazioneNeedleB]);
        var seq2 = SKAction.sequence([rotazionePernoA, rotazionePernoB]);
        
        self.lancetta.runAction(
            SKAction.repeatActionForever(seq)
        );
        self.pernoCentrale.runAction(
            SKAction.repeatActionForever(seq2)
        );
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
    }
    
    private func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (x: CGFloat, y: CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
    
    func enableYellowSection(level: Int){
        var angleRef = self.calcAngleOnLevel(level);
        var pathToDraw = CGPathCreateMutable()
        
        CGPathMoveToPoint(pathToDraw, nil, self.centerX, self.centerY)
        CGPathAddArc(pathToDraw, nil, self.centerX, self.centerY, self.radius, angleRef.max, angleRef.min, true);
        
        CGPathAddLineToPoint(pathToDraw, nil, self.centerX, self.centerY)
        
        for (obj) in self.children{
            if(self.yellowSectionShapeName == obj.name || self.yellowCollisionNodeName == obj.name){
                obj.removeFromParent();
            }
        }
        
        let myLine:SKShapeNode = SKShapeNode(path:pathToDraw)
        myLine.name = self.yellowSectionShapeName;
        myLine.path = pathToDraw
        myLine.strokeColor = SKColor.orangeColor()
        myLine.glowWidth = 0.6
        myLine.fillColor = SKColor.orangeColor().colorWithAlphaComponent(0.6);
        self.addChild(myLine)
        
        var offset : CGFloat = 0;
        var punto = findXY(self.radius-offset, centerX: self.centerX, centerY: self.centerY, angle: angleRef.max);
        var corda = (2  * (self.radius-offset)) * (sin(angleRef.dim/2));
        
        nodoCollisione = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: corda, height: 10));
        nodoCollisione.name = self.yellowCollisionNodeName;
        nodoCollisione.position = CGPoint(x: punto.x, y: punto.y);
        nodoCollisione.anchorPoint = CGPoint(x: 0, y: 1);
        nodoCollisione.zRotation = (angleRef.max - (angleRef.dim/2)) - Speedo.degreesToRadiant(90)
        nodoCollisione.physicsBody = SKPhysicsBody(rectangleOfSize: self.nodoCollisione.frame.size)
        nodoCollisione.physicsBody?.categoryBitMask = PhysicsCategory.CollisionBlockP
        nodoCollisione.physicsBody?.contactTestBitMask = PhysicsCategory.NeedleP
        nodoCollisione.physicsBody?.collisionBitMask = PhysicsCategory.Vuoto;
        nodoCollisione.physicsBody?.dynamic=false;
        nodoCollisione.physicsBody?.usesPreciseCollisionDetection=true;
        self.addChild(nodoCollisione)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //        for touch: AnyObject in touches {
        //            let location = touch.locationInNode(self)
        NSLog("click");
        if(self.colliso){
            self.colliso = false;
            self.enableYellowSection(self.currentLevel+1);
            //            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
    }
    
    private func randomDouble(min : Double , max : Double) -> Double{
        return (Double(arc4random())) / Double(UINT32_MAX) * (max-min) + min
    }
    
    private func calcAngleOnLevel(level : Int) -> (max : CGFloat, min : CGFloat, dim : CGFloat){
        self.currentLevel = level;
        
        //        NSLog("Calcolo dai punti di riferimento: \(self.minDegreeNeedleAngle) - \(self.maxDegreeNeedleAngle)");
        var dimAngle = (self.maxDegreeNeedleAngle - self.minDegreeNeedleAngle) / Double((self.currentLevel + 7))
        
        NSLog("Dimensione angolo: \(dimAngle) - minimo: \(self.minAngleYellowSection)");
        dimAngle = dimAngle < minAngleYellowSection ? minAngleYellowSection : dimAngle;
        
        // si applica una correzione di 90 gradi dovuta agli assi del piano di presentazione
        var rnd: Double = self.randomDouble(self.minDegreeNeedleAngle+dimAngle, max: (self.maxDegreeNeedleAngle)) + 90
        //        NSLog("Punto random: \(rnd)");
        
        return ( Speedo.degreesToRadiant(rnd), Speedo.degreesToRadiant(rnd-dimAngle), Speedo.degreesToRadiant(dimAngle));
    }
}