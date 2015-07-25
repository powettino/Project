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

protocol StartingActionDelegate{
    func startedGame();
}

class Speedo : SKScene{
    
    struct PhysicsCategory {
        static let NeedleP : UInt32 = 0b1
        static let CollisionBlockP : UInt32 = 0b10
        static let Empty : UInt32 = 0b0
    }
    
    static func getAccelleratorViewOffset(view : UIView) -> (w: CGFloat, h: CGFloat)
    {
        var res =  UtilityFunction.IOSDeviceUtility.checkDevice(view)
        NSLog("res: \(res.rawValue)")
        switch (res){
        case UtilityFunction.IOSDeviceUtility.IOSDeviceType.iPhone5:
            return (0,25)
        case UtilityFunction.IOSDeviceUtility.IOSDeviceType.iPhone6:
            return (0,55)
        case UtilityFunction.IOSDeviceUtility.IOSDeviceType.iPhone6Plus:
            return (0,75)
        default:
            return (0,0);
        }
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
            var punto = UtilityFunction.findXY(referenceAngles.radius-offset, centerX: centerPoint.x, centerY: centerPoint.y, angle: referenceAngles.angles.max);
            var corda = (2  * (referenceAngles.radius-offset)) * (sin(referenceAngles.angles.dim/2));
            
            colliderNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: corda, height: 10));
            colliderNode!.name = yellowName+"Collider";
            colliderNode!.position = CGPoint(x: punto.x, y: punto.y);
            colliderNode!.anchorPoint = CGPoint(x: 0, y: 1);
            colliderNode!.zRotation = (referenceAngles.angles.max - (referenceAngles.angles.dim/2)) - UtilityFunction.degreesToRadiant(90)
            //            colliderNode!.physicsBody = SKPhysicsBody(rectangleOfSize: colliderNode!.frame.size)
            //            colliderNode!.physicsBody?.categoryBitMask = PhysicsCategory.CollisionBlockP
            //            colliderNode!.physicsBody?.contactTestBitMask = PhysicsCategory.NeedleP
            //            colliderNode!.physicsBody?.collisionBitMask = PhysicsCategory.Empty;
            //            colliderNode!.physicsBody?.dynamic=false;
            //            colliderNode!.physicsBody?.usesPreciseCollisionDetection=true;
            yellowShape?.addChild(colliderNode!)
        }
        
        private static func calcAngleOnLevel(level : Int, minDegreeAngle : Double, maxDegreeAngle: Double) -> (max : CGFloat, min : CGFloat, dim : CGFloat){
            
            // si applica una correzione di 90 gradi dovuta agli assi del piano di presentazione
            // NSLog("Calcolo dai punti di riferimento: \(minDegreeAngle+90) - \(maxDegreeAngle+90)");
            var fixedAngles : (min: Double, max: Double) = (minDegreeAngle + 90, maxDegreeAngle + 90)
            var dimensionAngle = (fixedAngles.max - fixedAngles.min) / Double((level + 7))
            
            //NSLog("Dimensione angolo: \(dimensionAngle) - minimo: \( fixedAngles.min )");
            dimensionAngle = dimensionAngle < Speedo.minSectionDimension ? Speedo.minSectionDimension : dimensionAngle;
            
            var rnd: Double = UtilityFunction.randomDouble( (fixedAngles.min + dimensionAngle),  max: (fixedAngles.max))
            //NSLog("Punto random: \(rnd)");
            
            return ( UtilityFunction.degreesToRadiant(rnd), UtilityFunction.degreesToRadiant(rnd-dimensionAngle), UtilityFunction.degreesToRadiant(dimensionAngle));
        }
    }
    
    private final let lightNodeName : String = "lightNode"
    private final let yellowSectionShapeName : String = "yellowNode"
    private final let gridNodeName :String = "gridNode"
    private final let vetroNodeName :String = "vetroNode"
    private final let needleNodeName : String = "needleNode"
    private final let labelNodeName : String = "labelNode"
    private final let smokeNodeName : String = "smokeNode"
    private final let labelStandardText : String = "SPEED UP"
    
    private var enableFail = false;
    private var enableTouchStartGame = false;
    private final let minDegreeNeedleAngle : Double = -136   //-46
    private final let maxDegreeNeedleAngle : Double = 136   //226
    //    private final let radius : CGFloat = 132;
    private var currentLevel : Int = 1
    private var colliso : Bool = false;
    private var running : Bool = false
    private final let offset : (w: CGFloat, h: CGFloat) = (15,15)
    
    private var label: SKLabelNode!
    private var grid : SKSpriteNode!
    private var ambientLight : SKLightNode!
    private var vetro : SKSpriteNode!
    private var needle : Needle!
    private var yellowSection : YellowSection!
    private var maxAngle : CGFloat!
    private var minAngle : CGFloat!
    private static var minSectionDimension : Double = 10;
    private var centerX : CGFloat!;
    private var centerY : CGFloat!;
    
    var scoreDelegate : ScoreDelegate?
    var startingActionDelegate : StartingActionDelegate?
    
    override func didMoveToView(view: SKView) {
        self.view?.allowsTransparency = true
        self.backgroundColor = UIColor.clearColor()
        
        self.centerX = self.size.width/2;
        self.centerY = self.size.height/2;
        
        self.grid = SKSpriteNode(imageNamed: "speedo.png");
        self.grid.name = self.gridNodeName;
        self.grid.position = CGPoint(x: self.centerX, y: self.centerY)
        self.grid.size = CGSize(width: self.size.width - self.offset.w, height: self.size.width - self.offset.h);
        self.grid.physicsBody = nil;
        self.addChild(self.grid)
        
        //        ((self.size.height - self.offset.h)/2) - 17
        
        self.needle = Needle(spriteName: "needle.png", w: ((self.size.width - self.offset.w)/2 - 30)/3, maxH: ((self.size.width - self.offset.w)/2 - 30), posX: self.centerX, posY: self.centerY, posZ: CGFloat(1), name: self.needleNodeName, startingAngle: maxDegreeNeedleAngle, minAngle:minDegreeNeedleAngle, maxAngle: maxDegreeNeedleAngle, anchorPoint: CGPoint(x: 0.5,y: 0.15));
        
        self.yellowSection = YellowSection(startingLevel: self.currentLevel, minDegree: self.minDegreeNeedleAngle, maxDegree: self.maxDegreeNeedleAngle, centerX: self.centerX, centerY: self.centerY, rad: ((self.size.width - self.offset.w)/2 - 17), yellowSectionName: self.yellowSectionShapeName);
        
        if let needleNode = self.needle.spriteNode {
            self.addChild(needleNode);
        }
        
        if let  yellowNode = self.yellowSection.yellowShape {
            self.addChild(yellowNode);
        }
        
        //        self.vetro = SKSpriteNode(imageNamed: "glass.png");
        self.vetro = SKSpriteNode(imageNamed: "vetro3.png");
        self.vetro.name = self.vetroNodeName;
        self.vetro.position = CGPoint(x: self.centerX, y: self.centerY)
        self.vetro.size = CGSize(width: self.size.width - self.offset.w - 20, height: self.size.width - self.offset.h - 20);
        
        self.vetro.physicsBody = nil;
//                self.vetro.normalTexture = SKTexture(imageNamed: "lightNormalGlass.jpg")
//        self.vetro.normalTexture = SKTexture(imageNamed: "brokenGlass.jpg")
        self.vetro.lightingBitMask = 1;
        self.vetro.zPosition = 2
        
        self.addChild(self.vetro)
        
        //        self.label = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
        //        self.label = SKLabelNode(fontNamed: "BudmoJiggler-Regular")
        //        self.label = SKLabelNode(fontNamed: "Flame");
        self.label = SKLabelNode(fontNamed: "Blazed");
        self.label.text = self.labelStandardText
        self.label.name = self.labelNodeName;
        self.label.fontColor = UIColor.redColor();
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        self.label.position = CGPointMake(-self.label.frame.width, self.centerY+50);
        self.label.fontSize = 20;
        
        self.label.physicsBody = nil;
        self.addChild(self.label);
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        self.ambientLight = SKLightNode()
        self.ambientLight.name = self.lightNodeName
        self.ambientLight.falloff = 0;
//        self.ambientLight.position = CGPoint(x: 250, y: 60)
                self.ambientLight.position = CGPoint(x: 20, y: 300)
        self.ambientLight.categoryBitMask = 1
        self.addChild(self.ambientLight)
        
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
        }else{
            if(self.enableTouchStartGame){
                self.running = true;
                self.startingActionDelegate?.startedGame();
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
    
    func brakeGlass(){
        self.vetro.normalTexture = SKTexture(imageNamed: "brokenGlass.jpg")
    }
    
    func restoreGlass(){
        self.vetro.normalTexture = SKTexture(imageNamed: "lightNormalGlass.jpg")
    }
    
    func setNeedleSpeed(speed : Needle.NeedleSpeed){
        self.needle.setSpeed(speed);
    }
    
    func increaseSpeedTo(value : CGFloat){
        self.needle.increaseSpeedTo(value);
    }
    
    func enableTouchStartGame(enable: Bool){
        self.enableTouchStartGame = enable;
    }
    
    func enableFailDelegate(enable : Bool){
        self.enableFail = enable;
    }
    
    func animateText(text : String?){
        if let emitter = self.childNodeWithName(self.smokeNodeName) {
            NSLog("Skip emitter")
        }else{
            
            if let tempText = text {
                self.label.text = tempText
            }
            
            var originalPosition = self.label.position
            
            var midPoint = CGPointMake(self.centerX, self.centerY+50)
            var startingPoint = CGPointMake(-self.label.frame.width-10, self.centerY+50)
            var endingPoint = CGPointMake(self.size.width+self.label.frame.width+10, self.label.position.y)
            
            var inc = SKTMoveEffect(node: self.label, duration: 0.8, startPosition: startingPoint, endPosition:midPoint)
            inc.timingFunction = SKTTimingFunctionBackEaseOut
            
            var out = SKTMoveEffect(node: self.label, duration: 0.8, startPosition: self.label.position, endPosition: endingPoint)
            out.timingFunction = SKTTimingFunctionBackEaseIn
            
            self.label.runAction(SKAction.sequence([
                SKAction.actionWithEffect(inc),
                SKAction.waitForDuration(0.5),
                SKAction.actionWithEffect(out)]), completion:{
                    self.label.position = originalPosition
                    self.label.text = self.labelStandardText
            });
            
            var smokeEmitter = SKEmitterNode(fileNamed: "SmokeBrake");
            smokeEmitter.name = self.smokeNodeName
            //        self.smokeEmitter.position = CGPointMake(self.label.frame.width/2, 0)
            smokeEmitter.position = CGPointMake(self.centerX+(self.label.frame.width/2), self.centerY+50)
            
            self.runAction(SKAction.waitForDuration(0.3), completion: {self.addChild(smokeEmitter)});
            self.runAction(SKAction.waitForDuration(2), completion:{
                smokeEmitter.removeFromParent();
            });
        }
    }
    
    func startGame(){
        self.needle.startRotation();
        self.running=true;
        NSLog("velocita: \(self.needle.speed.rawValue)");
    }
    
    func stopNeedle(){
        self.running=false;
        self.needle.stopRotation();
    }
    
    func resetSpeedo(){
        self.stopNeedle();
        self.needle.increaseSpeedTo(1.0);
        self.needle.setStartPosition(maxDegreeNeedleAngle)
        self.currentLevel = 1;
        self.updateCollisionSection(self.currentLevel);
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
        //        for (obj) in self.children{
        //            if(self.yellowSectionShapeName == obj.name){
        //                obj.removeFromParent();
        //            }
        //        }
        self.enumerateChildNodesWithName(self.yellowSectionShapeName) {
            node, stop in
            node.removeFromParent();
        }
        
        self.yellowSection.updateSection(self.currentLevel, refMinDegree: self.minDegreeNeedleAngle, refMaxDegree: self.maxDegreeNeedleAngle, radius : (self.grid.size.height/2)-18);
        self.addChild(self.yellowSection.yellowShape!);
    }
    
    func isMinimunSectionDimension() -> Bool{
        return (self.yellowSection.referenceAngles.angles.dim == UtilityFunction.degreesToRadiant(Speedo.minSectionDimension));
    }
}

