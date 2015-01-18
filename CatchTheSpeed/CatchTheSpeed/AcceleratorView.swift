//
//  AcceleratorView.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

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
    
    private let offsetCircle: CGFloat = 30
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
    private var tickerAngle: CGFloat = 0
    private let tickerAnglePlus : CGFloat = (1/18) * CGFloat(M_PI)
    private var multiplier: CGFloat = 1
    private var coloredRadius :CGFloat = 0
    private var coloredStartingAngle: CGFloat = 0
    private var coloredEndingAngle : CGFloat = 0
    private var enableColored: Bool = false
    
    private   var puntiCerchio = puntiCirconferenza()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        calcolaPuntiBase(frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
        calcolaPuntiBase(frame)
    }
    
    private func drawTicker(inCanvas canvas: CGContext)
    {
        CGContextSaveGState(canvas)
        
        CGContextSetLineWidth(canvas, 1.0)
        CGContextSetStrokeColorWithColor(canvas, UIColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(canvas, UIColor.redColor().CGColor)
        
        CGContextMoveToPoint(canvas, centerX, centerY)
        
        var puntiExt = findXY(radius, centerX: centerX, centerY: centerY, angle: tickerAngle)
        CGContextAddLineToPoint(canvas, puntiExt.0, puntiExt.1)
        var punti = findXY(tickerRadius, centerX: centerX, centerY: centerY, angle: tickerAngle-((1/2)*pi))
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextAddLineToPoint(canvas, centerX, centerY)
        
        CGContextDrawPath(canvas, kCGPathFillStroke)
        
        CGContextSetFillColorWithColor(canvas, UIColor(red: CGFloat(255), green: CGFloat(127), blue: CGFloat(10), alpha: 1.0).CGColor)
        CGContextMoveToPoint(canvas, centerX, centerY)
        CGContextAddLineToPoint(canvas, puntiExt.0, puntiExt.1)
        
        punti = findXY(tickerRadius, centerX: centerX, centerY: centerY, angle: tickerAngle+((1/2)*pi))
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextAddLineToPoint(canvas, centerX, centerY)
        CGContextDrawPath(canvas, kCGPathFillStroke)
        CGContextRestoreGState(canvas)
    }
    
    override func drawRect(rect: CGRect) {
        let canvas = UIGraphicsGetCurrentContext()
        
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        let width = frame.size.width
        let height = frame.size.height
        
        CGContextMoveToPoint(canvas, 0, centerY)
        CGContextAddLineToPoint(canvas, width, height/2)
        CGContextStrokePath(canvas)
        CGContextMoveToPoint(canvas, width/2, 0)
        CGContextAddLineToPoint(canvas, width/2, height)
        CGContextStrokePath(canvas)
        drawExternalCircle(canvas)
        if (enableColored){
            drawColored(canvas)
        }
        drawLinee(canvas)
        drawCenterCircle(canvas)
        drawTicker(inCanvas: canvas)
    }
    
    func getReferenceAngleValue() -> (min: CGFloat, max: CGFloat){
        return (self.offsetAngle ,self.maxValueTick+self.offsetAngle)
    }
    
    
    func enableYellowSection(startingAngle: CGFloat, endingAngle:CGFloat){
        coloredStartingAngle = startingAngle
        coloredEndingAngle = endingAngle
        enableColored = true
    }
    
    func disableYellowSection()
    {
        enableColored=false
        coloredEndingAngle=0
        coloredStartingAngle=0
    }
    
    private func calcolaPuntiBase(frame: CGRect){
        var minDim = frame.size.width < frame.size.height ? frame.size.width : frame.size.height
        self.radius = (minDim-offsetCircle)/2
        self.externalRadius = radius + 1
        self.internalRadius = externalRadius-10
        self.minRadius = internalRadius * 3/25
        self.tickerRadius = minRadius*(2/5)
        self.coloredRadius = self.radius
        centerX = frame.size.width/2
        centerY = frame.size.height/2 + offsetCircle
        tickerAngle = offsetAngle
        for index in (0...Int(maxValueTick/precision)){
            var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addPointXY(x: punti.0, y: punti.1)
            punti = findXY(internalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addUnderPointXY(x: punti.0, y: punti.1)
            punti = findXY(externalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addOverPointXY(x: punti.0, y: punti.1)
        }
    }
    
    func addTickerAngle() -> Void{
        if( multiplier > 0){
            if((tickerAngle + (tickerAnglePlus * multiplier)) <= (maxValueTick + offsetAngle)){
                tickerAngle += tickerAnglePlus * multiplier
                self.setNeedsDisplay()
            }else{
                tickerAngle = maxValueTick + offsetAngle
                multiplier = -1
            }
        }else{
            if((tickerAngle + (tickerAnglePlus * multiplier)) >= offsetAngle){
                tickerAngle += tickerAnglePlus * multiplier
                self.setNeedsDisplay()
            }else{
                tickerAngle = offsetAngle
                multiplier = 1
            }
        }
     //   println("\(tickerAngle)")
    }
    
    func resetTicker() -> Void {
        tickerAngle = offsetAngle;
        self.setNeedsDisplay()
    }
    
    func getTickerAngle() -> CGFloat{
        return tickerAngle
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
        CGContextSetLineWidth(canvas, 5.0);
        CGContextAddArc(canvas, centerX, centerY, radius, offsetAngle, offsetAngle + (maxValueTick),0)
        var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: offsetAngle)
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextSetFillColorWithColor(canvas, UIColor.lightGrayColor().CGColor)
        CGContextDrawPath(canvas, kCGPathFillStroke)
        CGContextMoveToPoint(canvas, punti.0, punti.1)
        CGContextAddArc(canvas, centerX, (centerY+radius), radius, ((7/6)*pi), (11/6)*pi,0)
        CGContextSetFillColorWithColor(canvas, UIColor.grayColor().CGColor)
        CGContextFillPath(canvas)
        
        
    }
    
    private func drawCenterCircle(canvas :CGContext){
        CGContextSetFillColorWithColor(canvas, UIColor.blackColor().CGColor)
        CGContextAddArc(canvas, centerX, centerY, minRadius, offsetAngle, pi2 + (maxValueTick),0)
        CGContextFillPath(canvas)
        CGContextRestoreGState(canvas)
        
    }
    private func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (CGFloat, CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
    
    
    
}
