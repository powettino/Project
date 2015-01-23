//
//  AcceleratorView.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit
import QuartzCore

class AcceleratorView: UIView {
    
    
    struct puntiCirconferenza
    {
        var overPuntiBaseX : [CGFloat];
        var overPuntiBaseY : [CGFloat];
        
        var puntiBaseX : [CGFloat];
        var puntiBaseY : [CGFloat];
        
        var underPuntiBaseX : [CGFloat]
        var underPuntiBaseY : [CGFloat]
        
        init(){
            puntiBaseX = []
            puntiBaseY = []
            overPuntiBaseX = []
            overPuntiBaseY = []
            underPuntiBaseX = []
            underPuntiBaseY = []
        }
        
        mutating func addPointXY(x pointX : CGFloat,y pointY : CGFloat){
            puntiBaseX.append(pointX)
            puntiBaseY.append(pointY)
        }
        mutating func addUnderPointXY(x pointX: CGFloat,y pointY: CGFloat){
            underPuntiBaseY.append(pointY)
            underPuntiBaseX.append(pointX)
        }
        
        mutating func addOverPointXY(x pointX: CGFloat,y pointY: CGFloat){
            overPuntiBaseY.append(pointY)
            overPuntiBaseX.append(pointX)
        }
        
        func getPointXY(position: Int) -> (CGFloat, CGFloat){
            return (puntiBaseX[position], puntiBaseY[position])
        }
        
        func getOverPointXY(position:Int) -> (CGFloat, CGFloat){
            
            return (overPuntiBaseX[position], overPuntiBaseY[position])
            
        }
        
        func getUnderPointXY(position:Int) -> (CGFloat, CGFloat){
            
            return (underPuntiBaseX[position], underPuntiBaseY[position])
            
        }
    }
    
    private let offsetCircle: CGFloat = 0
    private let precision: CGFloat = ((1/36)*CGFloat(M_PI))
    private let maxValueTick: CGFloat = ((4/3)*CGFloat(M_PI))
    private let pi : CGFloat = CGFloat(M_PI)
    private let pi2 : CGFloat = (2*CGFloat(M_PI))
    private let offsetAngle : CGFloat = (5/6) * CGFloat(M_PI)
    private var externalRadius:CGFloat = 0
    private var radius : CGFloat = 0
    private var internalRadius:CGFloat = 0
    private var minRadius:CGFloat = 0
    private var tickerRadius : CGFloat = 0
    private var centerX: CGFloat = 0
    private var centerY:CGFloat = 0
    private var tickerAngleMov : Double = 0
    private var tickerAngle : Double = 0
    private var multiplier: CGFloat = 1
    private var coloredRadius :CGFloat = 0
    private var coloredStartingAngle: CGFloat = 0
    private var coloredEndingAngle : CGFloat = 0
    private var enableColored: Bool = false
    var shapeTicker : CAShapeLayer = CAShapeLayer()
    var trans : CGAffineTransform = CGAffineTransformIdentity
    var spin : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    var currentTimeTicking : Double = 0
    var stillRunning : Bool = false
    var startAngleMov : Double = 0
    private var puntiCerchio = puntiCirconferenza()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        calcolaPuntiBase(frame)
        drawTicker()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
        calcolaPuntiBase(frame)
        drawTicker()
    }
    
    var countIteraction = 1
    
    func animaTicker(ticking: Double){
        println( "\(countIteraction)")
        self.currentTimeTicking = ticking
        self.shapeTicker.anchorPoint = CGPoint(x: (0.5), y: (0.5))
        
        self.spin.removedOnCompletion = false;
        self.spin.fillMode = kCAFillModeForwards;
        
        let actualTick = self.tickerAngle
        
        if( self.multiplier > 0){
            if( (countIteraction % 5) == 0){
                println("entrato : \(tickerAngleMov)")
                self.tickerAngleMov += ((1 / 180) * M_PI)
            }
            if((self.tickerAngle + self.tickerAngleMov) <= Double(self.maxValueTick)){
                self.tickerAngle += self.tickerAngleMov
            }else{
                self.tickerAngle = Double(self.maxValueTick)
                self.multiplier = -1
            }
        }else{
            if(countIteraction % 5 == 0){
                println("adada: \(tickerAngleMov)")
                if( self.tickerAngleMov - ((1 / 180) * M_PI) < self.startAngleMov){
                    self.tickerAngleMov = self.startAngleMov
                }else{
                    self.tickerAngleMov -= (1 / 180) * M_PI
                }
            }
            if(self.tickerAngle - (self.tickerAngleMov) >= 0){
                self.tickerAngle -= self.tickerAngleMov
            }else{
                self.tickerAngle = 0
                self.multiplier = 1
            }
        }
        countIteraction++;
        
        
        self.spin.toValue = self.tickerAngle
        self.spin.fromValue = actualTick
        self.spin.repeatCount = 1
        self.spin.autoreverses = false
        self.spin.cumulative = false
        self.spin.delegate = self
        self.spin.duration = ticking
        self.stillRunning = true
        self.shapeTicker.addAnimation(spin, forKey: "ticking")
        
    }
    
    func bloccaTicker(){
        self.currentTimeTicking = 0
        self.stillRunning = false
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if(self.stillRunning){
            self.animaTicker(self.currentTimeTicking)
        }
    }
    
    
    private func drawTicker()
    {
        shapeTicker.frame = self.layer.bounds
        
        var path = CGPathCreateMutable()
        var subLayer1 = CAShapeLayer()
        subLayer1.frame = self.layer.bounds
        subLayer1.lineWidth = 1.0
        subLayer1.fillColor = UIColor.redColor().CGColor
        subLayer1.strokeColor=UIColor.blackColor().CGColor
        CGPathMoveToPoint(path, nil, centerX, centerY)
        
        var puntiExt = findXY(radius, centerX: centerX, centerY: centerY, angle: ((CGFloat(tickerAngle)*pi) / 180) + offsetAngle)
        CGPathAddLineToPoint(path, nil, puntiExt.0, puntiExt.1)
        
        var punti = findXY(tickerRadius, centerX: centerX, centerY: centerY, angle: ((CGFloat(tickerAngle)*pi) / 180) + offsetAngle - ((1/2)*pi))
        CGPathAddLineToPoint(path, nil, punti.0, punti.1)
        CGPathMoveToPoint(path, nil, centerX, centerY)
        
        CGPathCloseSubpath(path)
        
        subLayer1.path = path
        shapeTicker.insertSublayer(subLayer1, atIndex: 1)
        
        
        var subLayer2 = CAShapeLayer()
        subLayer2.frame = self.layer.bounds
        subLayer2.lineWidth = 1.0
        subLayer2.fillColor = UIColor(red: 0.3, green: 0.5, blue: 0.5, alpha: 0.4).CGColor
        subLayer2.strokeColor=UIColor.blackColor().CGColor
        
        var path2 = CGPathCreateMutable()
        CGPathMoveToPoint(path2, nil, centerX, centerY)
        punti = findXY(tickerRadius, centerX: centerX, centerY: centerY, angle: ((CGFloat(tickerAngle)*pi) / 180) + offsetAngle + ((1/2)*pi))
        CGPathAddLineToPoint(path2, nil, punti.0 , punti.1)
        CGPathAddLineToPoint(path2, nil, puntiExt.0, puntiExt.1)
        CGPathMoveToPoint(path2, nil, centerX, centerY)
        CGPathCloseSubpath(path2)
        subLayer2.path = path2
        
        shapeTicker.insertSublayer(subLayer2, atIndex: 0)
        
        var center = CAShapeLayer()
        var centerPath = CGPathCreateMutable()
        
        center.fillColor = UIColor.blackColor().CGColor
        CGPathAddArc(centerPath, nil, centerX, centerY, minRadius, offsetAngle, pi2 + (maxValueTick), false)
        CGPathCloseSubpath(centerPath)
        center.path = centerPath
        shapeTicker.addSublayer(center)
        
        self.layer.addSublayer(shapeTicker)
        
    }
    
    override func drawRect(rect: CGRect) {
        let canvas = UIGraphicsGetCurrentContext()
        CGContextSaveGState(canvas)
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        let width = frame.size.width
        let height = frame.size.height
        
//        CGContextMoveToPoint(canvas, 0, centerY)
//        CGContextAddLineToPoint(canvas, width, height/2)
//        CGContextStrokePath(canvas)
//        CGContextMoveToPoint(canvas, width/2, 0)
//        CGContextAddLineToPoint(canvas, width/2, height)
//        CGContextStrokePath(canvas)
        drawExternalCircle(canvas)
        if (enableColored){
            drawColored(canvas)
        }
        drawLinee(canvas)
        drawCenterCircle(canvas)
        
        CGContextRestoreGState(canvas)
    }
    
    func getReferenceAngleValue() -> (min: Double, max: Double){
        return (Double(self.offsetAngle * 180 ) / M_PI, Double((self.maxValueTick + self.offsetAngle)*180) / M_PI)
    }
    
    func enableYellowSection(startingAngle: Double, endingAngle:Double){
        coloredStartingAngle = CGFloat((startingAngle / 180 ) * M_PI)
        coloredEndingAngle = CGFloat((endingAngle / 180 ) * M_PI)
        enableColored = true
        self.setNeedsDisplay()
    }
    
    func disableYellowSection()
    {
        enableColored=false
        coloredEndingAngle=0
        coloredStartingAngle=0
    }
    
    private func calcolaPuntiBase(frame: CGRect){
        var minDim = frame.size.width < frame.size.height ? frame.size.width : frame.size.height
        self.radius = (minDim-15)/2
        self.externalRadius = radius + 1
        self.internalRadius = externalRadius-10
        self.minRadius = internalRadius * 3/25
        self.tickerRadius = minRadius*(2/5)
        self.coloredRadius = self.radius
        centerX = frame.size.width/2
        centerY = frame.size.height/2 + offsetCircle
        
        for index in (0...Int(maxValueTick/precision)){
            var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addPointXY(x: punti.0, y: punti.1)
            punti = findXY(internalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addUnderPointXY(x: punti.0, y: punti.1)
            punti = findXY(externalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addOverPointXY(x: punti.0, y: punti.1)
        }
    }
    
    func resetTicker() -> Void {
        self.shapeTicker.removeAnimationForKey("ticking")
        self.tickerAngle = 0;
    }
    
    func getTickerAngle() -> Double{
        return Double((tickerAngle + Double(offsetAngle)) * 180) / M_PI
    }
    
    func setTickerAngleMov(angle: Double){
        self.startAngleMov = (angle * M_PI) / 180
        self.tickerAngleMov = (angle * M_PI) / 180
    }
    
    private func drawColored(canvas :CGContext)
    {
        CGContextSaveGState(canvas)
        
        CGContextSetFillColorWithColor(canvas, UIColor.orangeColor().colorWithAlphaComponent(0.6).CGColor)
        CGContextSetLineWidth(canvas, 0.0)
        CGContextMoveToPoint(canvas, centerX, centerY)
        CGContextAddArc(canvas, centerX, centerY, radius, coloredStartingAngle, coloredEndingAngle ,0)
        
        var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: offsetAngle)
        CGContextMoveToPoint(canvas,  punti.0, punti.1)
        
        CGContextDrawPath(canvas, kCGPathFillStroke)
        
        CGContextRestoreGState(canvas)
    }
    
    private func drawLinee(canvas: CGContext){
        CGContextSaveGState(canvas)
        for index in (0...Int(maxValueTick/precision)){
            if(index % 4 == 0){
                CGContextSetStrokeColorWithColor(canvas, UIColor.redColor().CGColor)
            }else{
                CGContextSetStrokeColorWithColor(canvas, UIColor.blackColor().CGColor)
            }
            CGContextSetLineWidth(canvas, 2.0);
            CGContextMoveToPoint(canvas, puntiCerchio.getOverPointXY(index).0, puntiCerchio.getOverPointXY(index).1)
            CGContextAddLineToPoint(canvas, puntiCerchio.getUnderPointXY(index).0, puntiCerchio.getUnderPointXY(index).1)
            CGContextStrokePath(canvas)
        }
        CGContextRestoreGState(canvas)
    }
    
    private func drawExternalCircle(canvas: CGContext) {
        CGContextSaveGState(canvas)
        CGContextSetLineWidth(canvas, 4.0);
        CGContextAddArc(canvas, centerX, centerY, radius, offsetAngle, offsetAngle + (maxValueTick),0)
        var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: offsetAngle)
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextSetFillColorWithColor(canvas, UIColor.lightGrayColor().CGColor)
        CGContextDrawPath(canvas, kCGPathFillStroke)
        CGContextMoveToPoint(canvas, punti.0, punti.1)
        CGContextAddArc(canvas, centerX, (centerY+radius), radius, ((7/6)*pi), (11/6)*pi,0)
        CGContextSetFillColorWithColor(canvas, UIColor.grayColor().CGColor)
        CGContextFillPath(canvas)
        CGContextRestoreGState(canvas)
        
    }
    
    private func drawCenterCircle(canvas :CGContext){
        
        
        //        CGContextSaveGState(canvas)
        //        CGContextSetFillColorWithColor(canvas, UIColor.blackColor().CGColor)
        //        CGContextAddArc(canvas, centerX, centerY, minRadius, offsetAngle, pi2 + (maxValueTick),0)
        //        CGContextFillPath(canvas)
        //        CGContextRestoreGState(canvas)
        
    }
    private func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (CGFloat, CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
}
