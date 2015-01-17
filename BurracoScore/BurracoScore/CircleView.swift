//
//  CircleView.swift
//  BurracoScore
//
//  Created by Iacopo on 17/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
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
    
    let offsetCircle: CGFloat = 40
    let precision: CGFloat = ((1/36)*CGFloat(M_PI))
    let maxValueTick: CGFloat = ((25/18)*CGFloat(M_PI))
    let pi : CGFloat = CGFloat(M_PI)
    let pi2 : CGFloat = (2*CGFloat(M_PI))
    let offsetAngle : CGFloat = (5/6) * CGFloat(M_PI)
    var externalRadius:CGFloat = 0
    var radius : CGFloat = 0
    var internalRadius:CGFloat = 0
    var minRadius:CGFloat = 0
    var centerX: CGFloat = 0
    var centerY:CGFloat = 0
    var tickerAngle: CGFloat = 0
    
    var puntiCerchio = puntiCirconferenza()
    
    
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
        
       CGContextSetStrokeColorWithColor(canvas, UIColor.blackColor().CGColor)
       CGContextSetFillColorWithColor(canvas, UIColor.grayColor().CGColor)
        
        CGContextMoveToPoint(canvas, centerX, centerY)
        CGContextAddLineToPoint(canvas, puntiCerchio.getPointXY(Int(tickerAngle/precision)).0, puntiCerchio.getPointXY(Int(tickerAngle/precision)).1)
        var puntoX = centerX + (minRadius * cos((1/4)*pi))
        var puntoY = centerY + (minRadius * sin((1/4)*pi))
        CGContextAddLineToPoint(canvas, puntoX, puntoY)
        CGContextAddLineToPoint(canvas, centerX, centerY)
        
       CGContextDrawPath(canvas, kCGPathFillStroke)
        
        CGContextSetFillColorWithColor(canvas, UIColor.lightGrayColor().CGColor)
        CGContextMoveToPoint(canvas, centerX, centerY)
        CGContextAddLineToPoint(canvas, puntiCerchio.getPointXY(Int(tickerAngle/precision)).0, puntiCerchio.getPointXY(Int(tickerAngle/precision)).1)
        puntoX = centerX + (minRadius * cos((5/4)*pi))
        puntoY = centerY + (minRadius * sin((5/4)*pi))
        CGContextAddLineToPoint(canvas, puntoX, puntoY)
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
        drawTicker(inCanvas: canvas)
        drawVisibleCircle(canvas, sizeX: width, sizeY: height)
        drawLinee(canvas)
    }
    
    final func calcolaPuntiBase(frame: CGRect){
        self.radius = (frame.size.width-offsetCircle)/2
        self.externalRadius = radius + 3
        self.internalRadius = externalRadius-10
        self.minRadius = internalRadius-(radius*(5/6))
        centerX = frame.size.width/2
        centerY = frame.size.height/2
        for index in (0...Int(maxValueTick/precision)){
            let puntoX = centerX + (radius * cos((CGFloat(index) * precision)+offsetAngle))
            let puntoY = centerY + (radius * sin((CGFloat(index) * precision)+offsetAngle))
            puntiCerchio.addPointXY(x: puntoX, y: puntoY)
            let underPuntoX = centerX + (internalRadius * cos((CGFloat(index) * precision)+offsetAngle))
            let underPuntoY = centerY + (internalRadius * sin((CGFloat(index) * precision)+offsetAngle))
            puntiCerchio.addUnderPointXY(x: underPuntoX, y: underPuntoY)
            let overPuntoX = centerX + (externalRadius * cos((CGFloat(index) * precision)+offsetAngle))
            let overPuntoY = centerY + (externalRadius * sin((CGFloat(index) * precision)+offsetAngle))
            puntiCerchio.addOverPointXY(x: overPuntoX, y: overPuntoY)
            
        }
    }
    
    func setnewTickerAngle(newAngle angle: CGFloat){
        tickerAngle = angle;
        self.setNeedsDisplay()
        println("ciaoi")
        
    }
    
    func getTickerAngle() -> CGFloat{
        return tickerAngle
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
    
    private func drawVisibleCircle(canvas: CGContext, sizeX: CGFloat , sizeY: CGFloat ) {
        CGContextSaveGState(canvas)
        CGContextAddArc(canvas, centerX, centerY, radius, offsetAngle, offsetAngle + (maxValueTick-precision),0)
        CGContextStrokePath(canvas)
        CGContextSetFillColorWithColor(canvas, UIColor.blackColor().CGColor)
        CGContextAddArc(canvas, centerX, centerY, minRadius, offsetAngle, pi2 + (maxValueTick-precision),0)
        CGContextFillPath(canvas)
        CGContextStrokePath(canvas)
        CGContextRestoreGState(canvas)
    }
    
    
    
}
